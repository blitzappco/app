import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../maps/routes.dart' as routes;
import '../maps/polyline_parse.dart';
import '../maps/waypoint.dart';

import '../models/step.dart';
import '../models/ticket.dart';
import '../utils/get_location.dart';
import '../maps/place.dart';
import '../maps/predictions.dart';
import '../utils/url.dart';

// import '../components/routing/route_option.dart';
// import '../components/routing/step_options.dart';
import '../models/segment.dart';

class RouteProvider with ChangeNotifier {
  int routeIndex = 0;

  bool loading = false;
  String errorMessage = '';

  bool showAnimation = false;
  bool runAnimation = false;

  changeShowAnimation(bool value) {
    showAnimation = value;
    notifyListeners();
  }

  changeRunAnimation(bool value) {
    runAnimation = value;
    notifyListeners();
  }

  setLoading(bool v) {
    loading = v;
    notifyListeners();
  }

  dynamic data = {};

  bool navMode = false;
  bool ticketoverlay = false;

  List<Place> predictions = [];

  Waypoint from = Waypoint(address: '', name: '', lat: 0.0, long: 0.0);
  Waypoint to = Waypoint(address: '', name: '', lat: 0.0, long: 0.0);

  LatLngBounds bounds = LatLngBounds(
    southwest: const LatLng(0.0, 0.0),
    northeast: const LatLng(0.0, 0.0),
  );

  toggleTicketOverlay() {
    ticketoverlay = !ticketoverlay;

    notifyListeners();
  }

  toggleNavMode() {
    navMode = !navMode;

    notifyListeners();
  }

  List<Polyline> polylines = [
    const Polyline(polylineId: PolylineId("polyline0")),
    const Polyline(polylineId: PolylineId("polyline1")),
    const Polyline(polylineId: PolylineId("polyline2")),
    const Polyline(polylineId: PolylineId("polyline3")),
    const Polyline(polylineId: PolylineId("polyline4")),
    const Polyline(polylineId: PolylineId("polyline5")),
    const Polyline(polylineId: PolylineId("polyline6")),
    const Polyline(polylineId: PolylineId("polyline7")),
    const Polyline(polylineId: PolylineId("polyline8")),
    const Polyline(polylineId: PolylineId("polyline9")),
  ];

  Set<Polyline> polylinesSet = <Polyline>{
    const Polyline(polylineId: PolylineId("polyline0")),
    const Polyline(polylineId: PolylineId("polyline1")),
    const Polyline(polylineId: PolylineId("polyline2")),
    const Polyline(polylineId: PolylineId("polyline3")),
    const Polyline(polylineId: PolylineId("polyline4")),
    const Polyline(polylineId: PolylineId("polyline5")),
    const Polyline(polylineId: PolylineId("polyline6")),
    const Polyline(polylineId: PolylineId("polyline7")),
    const Polyline(polylineId: PolylineId("polyline8")),
    const Polyline(polylineId: PolylineId("polyline9")),
  };

  List<List<Polyline>> polylinesList = [];
  List<List<Segment>> segmentsList = [];
  List<int> noLines = [];
  List<List<String>> lines = [];
  List<Map<String, String>> metaList = [];

  List<List<StepModel>> stepsList = [];

  // List<RouteOption> routeOptionsList = [];

  String page = 'home';
  List<double> mapPadding = [0, 100, 200, 250];

  changePage(String newPage) {
    page = newPage;

    switch (page) {
      case 'preview':
        mapPadding = [300];
        break;
      case 'home':
        mapPadding = [0, 100, 200, 250];
        break;
    }

    notifyListeners();
  }

  Position? position;

  setPosition(Position? newPos) {
    position = newPos;
    notifyListeners();
  }

  bool cfShown = true;
  changeCFShown(bool value) {
    cfShown = value;
    notifyListeners();
  }

  deleteData() async {
    routeIndex = 0;

    loading = false;

    from = Waypoint(address: '', name: '', lat: 0.0, long: 0.0);
    to = Waypoint(address: '', name: '', lat: 0.0, long: 0.0);

    bounds = LatLngBounds(
      southwest: const LatLng(0.0, 0.0),
      northeast: const LatLng(0.0, 0.0),
    );

    data = {};

    polylines = [
      const Polyline(polylineId: PolylineId("polyline0")),
      const Polyline(polylineId: PolylineId("polyline1")),
      const Polyline(polylineId: PolylineId("polyline2")),
      const Polyline(polylineId: PolylineId("polyline3")),
      const Polyline(polylineId: PolylineId("polyline4")),
      const Polyline(polylineId: PolylineId("polyline5")),
      const Polyline(polylineId: PolylineId("polyline6")),
      const Polyline(polylineId: PolylineId("polyline7")),
      const Polyline(polylineId: PolylineId("polyline8")),
      const Polyline(polylineId: PolylineId("polyline9")),
    ];

    polylinesSet = <Polyline>{
      const Polyline(polylineId: PolylineId("polyline0")),
      const Polyline(polylineId: PolylineId("polyline1")),
      const Polyline(polylineId: PolylineId("polyline2")),
      const Polyline(polylineId: PolylineId("polyline3")),
      const Polyline(polylineId: PolylineId("polyline4")),
      const Polyline(polylineId: PolylineId("polyline5")),
      const Polyline(polylineId: PolylineId("polyline6")),
      const Polyline(polylineId: PolylineId("polyline7")),
      const Polyline(polylineId: PolylineId("polyline8")),
      const Polyline(polylineId: PolylineId("polyline9")),
    };

    // polylinesList = [];
    segmentsList = [];
    metaList = [];

    // routeOptionsList = [];
  }

  loadPolylines() {
    for (int i = 0; i < polylines.length; i++) {
      if (i < polylinesList[routeIndex].length) {
        polylines[i] = Polyline(polylineId: polylines[i].polylineId);
        polylines[i] = Polyline(
          polylineId: polylines[i].polylineId,
          color: polylinesList[routeIndex][i].color,
          patterns: polylinesList[routeIndex][i].patterns,
          points: polylinesList[routeIndex][i].points,
          width: polylinesList[routeIndex][i].width,
        );
      } else {
        polylines[i] = Polyline(polylineId: polylines[i].polylineId);
      }
    }
  }

  deletePolylines() {
    polylinesSet = <Polyline>{
      const Polyline(polylineId: PolylineId("polyline0")),
      const Polyline(polylineId: PolylineId("polyline1")),
      const Polyline(polylineId: PolylineId("polyline2")),
      const Polyline(polylineId: PolylineId("polyline3")),
      const Polyline(polylineId: PolylineId("polyline4")),
      const Polyline(polylineId: PolylineId("polyline5")),
      const Polyline(polylineId: PolylineId("polyline6")),
      const Polyline(polylineId: PolylineId("polyline7")),
      const Polyline(polylineId: PolylineId("polyline8")),
      const Polyline(polylineId: PolylineId("polyline9")),
    };

    notifyListeners();
  }

  changeRouteIndex(int index) async {
    routeIndex = index;

    loadPolylines();
    polylinesSet = Set<Polyline>.of(polylines);

    notifyListeners();
  }

  loadData() async {
    bounds = LatLngBounds(
      southwest: LatLng(
        from.lat < to.lat ? from.lat : to.lat,
        from.long < to.long ? from.long : to.long,
      ),
      northeast: LatLng(
        from.lat > to.lat ? from.lat : to.lat,
        from.long > to.long ? from.long : to.long,
      ),
    );

    // getting the routes
    data = await getRoutes();

    // getting polylines
    polylinesList = parsePolylines(data);

    // segments
    final parseSegmentsResult = parseSegments(data);
    segmentsList = parseSegmentsResult['segments'];
    noLines = parseSegmentsResult['noLines'];
    lines = parseSegmentsResult['lines'];

    // metadata
    metaList = parseMeta(data);
    // and steps
    stepsList = parseSteps(data);

    loadPolylines();
    polylinesSet = Set<Polyline>.of(polylines);

    notifyListeners();
  }

  Ticket ticket = Ticket();
  String selectedTicketType = '0';

  changeSelectedTicketType(String input) {
    selectedTicketType = input;
    notifyListeners();
  }

  getLastTicket(String token) async {
    final response = await http.get(
      Uri.parse("${AppURL.baseURL}/tickets/last"),
      headers: authHeader(token),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ticket = Ticket.fromJSON(json);

      notifyListeners();
    }
  }

  buyTicket(
    String token,
  ) async {
    print('debug: $selectedTicketType');
    loading = true;
    notifyListeners();

    final response = await http.post(
        Uri.parse("${AppURL.baseURL}/tickets/buy?typeID=$selectedTicketType"),
        headers: authHeader(token),
        body: jsonEncode(<String, dynamic>{}));

    loading = false;
    notifyListeners();

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ticket = Ticket.fromJSON(json['ticket']);

      notifyListeners();
    } else {
      errorMessage = json['message'];
      notifyListeners();
    }
  }

  getPredictions(String input) async {
    predictions = await getPlacePredictions(input);
    notifyListeners();
  }

  setFrom(Waypoint wp) {
    from = wp;
    notifyListeners();
  }

  setTo(Waypoint wp) {
    to = wp;
    notifyListeners();
  }

  getRoutes() async {
    return await routes.getRoutes(
      '${from.lat},${from.long}',
      '${to.lat},${to.long}',
    );
  }

  initFrom() async {
    final pos = await getCurrentLocation();

    final wp = await waypointFromCoordinates(
      pos?.latitude ?? 0.0,
      pos?.longitude ?? 0.0,
    );

    from = wp;
    notifyListeners();
  }

  selectFrom(Place place) async {
    final wp = await waypointFromPlace(place);

    from = wp;
    notifyListeners();
  }

  selectTo(Place place) async {
    final wp = await waypointFromPlace(place);

    to = wp;
    notifyListeners();
  }
}
