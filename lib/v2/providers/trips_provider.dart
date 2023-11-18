import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/trip.dart';
import '../utils/url.dart';

class TripsProvider with ChangeNotifier {
  List<Trip> trips = [];

  bool loading = false;
  String errorMessage = '';

  addTrip(
    String token,
    Trip trip,
  ) async {
    loading = true;
    notifyListeners();

    final response = await http.post(
        Uri.parse('${AppURL.baseURL}/accounts/trips'),
        headers: authHeader(token),
        body: jsonEncode(trip.toJSON()));

    loading = false;
    notifyListeners();

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      trips = [Trip.fromJSON(json), ...trips];
      notifyListeners();
    } else {
      errorMessage = json['message'];
      notifyListeners();
    }
  }

  getTrips(String token) async {
    loading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('${AppURL.baseURL}/accounts/trips'),
      headers: authHeader(token),
    );
    loading = false;
    notifyListeners();

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      for (int i = 0; i < json.length; i++) {
        trips.add(Trip.fromJSON(json[i]));
      }
      notifyListeners();
    } else {
      errorMessage = json['message'];
      notifyListeners();
    }
  }
}
