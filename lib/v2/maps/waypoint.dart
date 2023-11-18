import 'geocode.dart';

import 'place.dart';

class Waypoint {
  double lat;
  double long;
  String name;
  String address;

  Waypoint({
    required this.lat,
    required this.long,
    required this.address,
    required this.name,
  });
}

Future<Waypoint> waypointFromCoordinates(double lat, double long) async {
  final place = await getPlaceName(lat, long);

  return Waypoint(lat: lat, long: long, address: place, name: place);
}

Future<Waypoint> waypointFromPlace(Place place) async {
  final coords = await getCoordinates('${place.name}, ${place.address}');

  return Waypoint(
    lat: coords['latitude'] ?? 0.0,
    long: coords['longitude'] ?? 0.0,
    address: place.address,
    name: place.name,
  );
}
