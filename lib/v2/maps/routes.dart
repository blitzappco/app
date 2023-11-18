import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/env.dart';

Future<dynamic> getRoutes(String from, String to) async {
  final url = 'https://maps.googleapis.com/maps/api/directions/json?language=ro'
      '&transit_mode=bus|tram&alternatives=true'
      '&origin=$from&destination=$to&mode=transit&key=$mapKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));

    return data;
  } else {
    throw Exception('Failed to fetch routes');
  }
}
