import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/env.dart';

import 'place.dart';

Future<List<Place>> getPlacePredictions(String input) async {
  final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input timisoara'
          '&components=country:RO'
          '&key=$mapKey'));

  List<Place> predictions = [];
  if (response.statusCode == 200) {
    const maxLengthDescription = 38; // Maximum length for the description
    const maxLengthName = 26;
    final rawPredictions = json.decode(response.body)['predictions'];
    predictions = rawPredictions.map<Place>((prediction) {
      String description = prediction['description'];
      String name = prediction['structured_formatting']['main_text'];
      if (description.length > maxLengthDescription) {
        description = '${description.substring(0, maxLengthDescription)}...';
      }
      if (name.length > maxLengthName) {
        name = '${name.substring(0, maxLengthName)}...';
      }
      return Place(
        address: description,
        type: 'n/a',
        name: name,
      );
    }).toList();
  } else {
    throw Exception('Failed to fetch place predictions');
  }

  return predictions;
}
