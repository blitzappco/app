import 'dart:convert';

import 'package:flutter/material.dart';
import '../utils/url.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  bool badWeather = false;
  double temp = 0;
  String icon = '';

  List<int> badConditions = [
    302,
    312,
    313,
    314,
    502,
    503,
    504,
    504,
    22,
    532,
    602,
    622,
    781
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=45.7653744&lon=21.2251112&appid=26ecfa7d6ab263ad21b21a85a1175c69'),
        headers: basicHeader,
      );

      dynamic json = jsonDecode(response.body);

      final code = json['weather'][0]['id'];
      print('debug: ${json['weather'][0]}');

      if (badConditions.contains(code / 100)) {
        setState(() {
          badWeather = true;
          icon =
              'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@1x.png';
        });
      }

      print('debug: $badWeather');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: .4,
              blurRadius: 100,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: badWeather
              ? Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              size: 20,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Bad Weather',
                                style: TextStyle(
                                    fontFamily: 'UberMoveBold',
                                    fontSize: 20,
                                    color: Colors.amber[700])),
                          ],
                        ),
                        const Text(
                            'There might be disruptions or delays caused by \nbad weather.')
                      ],
                    )
                  ],
                )
              : ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud, size: 20),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "15°",
                        style: TextStyle(
                            fontFamily: 'UberMoveMedium', fontSize: 15),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
