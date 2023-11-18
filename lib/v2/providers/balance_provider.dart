import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/url.dart';
import 'package:http/http.dart' as http;

class BalanceProvider with ChangeNotifier {
  double value = 0.0;

  bool loading = false;
  String errorMessage = '';

  getBalance(String token) async {
    loading = true;
    notifyListeners();

    final response = await http.get(
        Uri.parse("${AppURL.baseURL}/accounts/balance"),
        headers: authHeader(token));

    loading = false;
    notifyListeners();

    dynamic json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      value = json['value'].toDouble();
      notifyListeners();
    } else {
      errorMessage = 'A aparut o eroare, va rugam incercati mai tarziu';
      notifyListeners();
    }
  }
}
