import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/env.dart';
import 'place.dart';

Future<Map<String, double>> getCoordinates(String place) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=$place&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List<dynamic>;

    if (results.isNotEmpty) {
      final location = results[0]['geometry']['location'];
      final lat = location['lat'] as double;
      final lng = location['lng'] as double;

      return {'latitude': lat, 'longitude': lng};
    }
  }

  // Failed to convert place to latlng
  return {'latitude': 0.0, 'longitude': 0.0};
}

Future<Place> getPlace(double latitude, double longitude) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$latitude,$longitude&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  var place = Place(
    name: '',
    address: '',
    type: '',
  );

  if (response.statusCode == 200) {
    final result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'OK') {
      var addressComponents = result['results'][0]['address_components'];
      place.name = addressComponents[0]['short_name'];
      place.address =
          "${addressComponents[1]['short_name']}, ${addressComponents[2]['short_name']}";
      place.type = addressComponents[0]['types'][0];
    }
  }

  return place;
}

Future<String> getPlaceName(double latitude, double longitude) async {
  final url = 'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$latitude,$longitude&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final result = json.decode(utf8.decode(response.bodyBytes));
    if (result['status'] == 'OK') {
      return result['results'][0]['formatted_address'];
    }
  }

  return '';
}

Future<Map<String, Map<String, double>>> getCoordinatesRoute(
  String fromLocation,
  String toLocation,
) async {
  try {
    final fromLatLng = await getCoordinates(fromLocation);
    final toLatLng = await getCoordinates(toLocation);

    return {
      'from': fromLatLng,
      'to': toLatLng,
    };
  } catch (e) {
    throw Exception('Error getting latLng for locations: $e');
  }
}
