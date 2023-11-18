import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> decodePolyline(String polyline) {
  final List<LatLng> decodedPoints = [];

  int index = 0;
  int lat = 0;
  int lng = 0;

  while (index < polyline.length) {
    int shift = 0;
    int result = 0;
    int byte;

    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);

    lat += (result & 1) == 1 ? ~(result >> 1) : (result >> 1);

    shift = 0;
    result = 0;

    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);

    lng += (result & 1) == 1 ? ~(result >> 1) : (result >> 1);

    double latitude = lat / 1e5;
    double longitude = lng / 1e5;

    decodedPoints.add(LatLng(latitude, longitude));
  }

  return decodedPoints;
}
