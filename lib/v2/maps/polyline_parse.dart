import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/step.dart';
import '../utils/env.dart';
import '../models/segment.dart';

// import '../components/routing/step_options.dart';

import './polyline_decode.dart';

Polyline walkingPolyline(List<LatLng> points) {
  return Polyline(
    polylineId: const PolylineId('walking'),
    color: Colors.grey,
    patterns: const [PatternItem.dot],
    points: points,
    width: 5,
  );
}

Polyline transitPolyline(Color color, List<LatLng> points) {
  return Polyline(
    polylineId: const PolylineId('transit'),
    color: color,
    points: points,
    width: 5,
  );
}

// Parses the polylines in the google map data
// to be transformed in dynamic representations
// of the transit routes
List<List<Polyline>> parsePolylines(dynamic data) {
  final dynamic routes = data['routes'];

  List<List<Polyline>> result = [];

  // going over each of the routes presented in the data
  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    // creating the list of polylines
    // of different types
    // for the current route
    List<Polyline> routePolylines = [];

    // going over each step
    // in the current route route
    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      // decoding the polyline into points to be represented on the map
      final List<LatLng> stepPoints =
          decodePolyline(steps[stepIndex]['polyline']['points']);

      // instantiating the polyline
      Polyline stepPolyline = const Polyline(polylineId: PolylineId('?'));

      String travelMode = steps[stepIndex]['travel_mode'];
      if (travelMode == "WALKING") {
        stepPolyline = walkingPolyline(stepPoints);
      } else {
        // name of line and color
        // for transit
        String line = steps[stepIndex]['transit_details']['line']['short_name'];
        Color lineColor = lineColors[line] ?? Colors.black;

        stepPolyline = transitPolyline(lineColor, stepPoints);
      }

      // adding the step polyline
      // to the route polylines
      routePolylines.add(stepPolyline);
    }

    // adding the route polylines
    // to the total result
    result.add(routePolylines);
  }

  return result;
}

// Parses the instructions in the google map data
// to be used for the shorthand representation of a route
Map<String, dynamic> parseSegments(dynamic data) {
  final dynamic routes = data['routes'];

  List<List<Segment>> segments = [];
  List<int> noLines = [];
  List<List<String>> lines = [];

  // going over each of the routes in data
  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    // getting the list of steps
    // in the current route
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    // instantiating segments
    // the transit lines
    // and the number of lines for each route
    List<Segment> routeSegments = [];
    List<String> routeLines = [];
    int routeNoLines = 0;

    // going over each step in the current route
    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      // travel mode & duration
      String travelMode = steps[stepIndex]['travel_mode'];
      int duration =
          int.parse(steps[stepIndex]['duration']['text'].split(' ')[0]);

      // line, type of line and color
      // for transit
      String line = '';
      String type = '';

      if (travelMode == "TRANSIT") {
        // line data
        dynamic lineData = steps[stepIndex]['transit_details']['line'];

        line = lineData['short_name'];

        // incrementing no of lines,
        // and adding line to lines of route
        routeNoLines++;
        routeLines.add(line);

        type = lineData['vehicle']['type'];
      }

      // creating the segment
      Segment stepSegment = Segment(
        isWalk: travelMode == "WALKING",
        time: duration,
        lineName: line,
        lineType: type,
      );

      // adding the segments to the route segments
      routeSegments.add(stepSegment);
    }

    // adding the lines for each route
    noLines.add(routeNoLines);
    lines.add(routeLines);

    // and the segments for each route
    // to the list
    segments.add(routeSegments);
  }

  return {
    "segments": segments,
    "noLines": noLines,
    "lines": lines,
  };
}

List<Map<String, String>> parseMeta(dynamic data) {
  final dynamic routes = data['routes'];

  List<Map<String, String>> result = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic legs = routes[routeIndex]['legs'][0];
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];
    final dynamic duration = routes[routeIndex]['legs'][0]['duration']['text'];

    String fromLoc = '';
    String leaveAt = '';

    bool isTransit = false;

    for (int stepsIndex = 0; stepsIndex < steps.length; stepsIndex++) {
      if (steps[stepsIndex]['travel_mode'] == "TRANSIT") {
        fromLoc =
            steps[stepsIndex]['transit_details']['departure_stop']['name'];

        if (leaveAt == '') {
          leaveAt =
              steps[stepsIndex]['transit_details']['departure_time']['text'];
        }
        isTransit = true;

        break;
      }
    }

    if (isTransit) {
      result.add(<String, String>{
        // "leaveAt": "la ${legs['departure_time']['text']}",
        'leaveAt': 'Leaves at $leaveAt',
        "arrivalTime": "${legs['arrival_time']['text']}",
        "fromLoc": fromLoc,
        'duration': duration,
      });
    } else {
      result.add(<String, String>{
        "leaveAt": 'Leave now',
        "arrivalTime": "in ${legs['duration']['text']}",
        "fromLoc": legs['start_address'],
        'duration': duration,
      });
    }
  }

  return result;
}

List<List<StepModel>> parseSteps(dynamic data) {
  // main routes
  final dynamic routes = data['routes'];

  List<List<StepModel>> stepsList = [];

  for (int routeIndex = 0; routeIndex < routes.length; routeIndex++) {
    final dynamic steps = routes[routeIndex]['legs'][0]['steps'];

    List<StepModel> routeSteps = [];

    for (int stepIndex = 0; stepIndex < steps.length; stepIndex++) {
      dynamic step = steps[stepIndex];

      if (step['travel_mode'] == "WALKING") {
        routeSteps.add(StepModel(
          type: 'walking',
          distance: step['distance']['text'],
          time: step['duration']['text'],
          line: '',
          fromStation: '',
          toStation: '',
          headsign: '',
          numStops: 0,
        ));
      } else {
        dynamic details = steps[stepIndex]['transit_details'];

        // get in
        routeSteps.add(StepModel(
          type: 'getIn',
          time: details['departure_time']['text'],
          distance: '',
          line: details['line']['short_name'],
          fromStation: details['departure_stop']['name'],
          toStation: details['arrival_stop']['name'],
          headsign: details['headsign'],
          numStops: details['num_stops'],
        ));

        routeSteps.add(StepModel(
          type: 'getOut',
          time: details['departure_time']['text'],
          distance: '',
          line: details['line']['short_name'],
          fromStation: details['departure_stop']['name'],
          toStation: details['arrival_stop']['name'],
          headsign: details['headsign'],
          numStops: details['num_stops'],
        ));
      }
    }

    routeSteps.add(StepModel(
      type: "destination",
      time: '',
      distance: '',
      line: '',
      fromStation: '',
      toStation: '',
      headsign: '',
      numStops: 2,
    ));

    stepsList.add(routeSteps);
  }

  return stepsList;
}
