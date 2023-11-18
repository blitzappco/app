import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/weather.dart';
import '../providers/trips_provider.dart';
import 'modals/profile_modal.dart';
import 'places/recents.dart';
import 'static_searchbar.dart';

class HomeComponent extends StatefulWidget {
  const HomeComponent({super.key});

  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: Consumer<TripsProvider>(builder: (context, trips, _) {
        return Column(
          children: [
            const Weather(),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const StaticSearchbar(),
                        GestureDetector(
                          onTap: () {
                            ProfileModal.show(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/Images/logoa.png')),
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              height: 45,
                              width: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (trips.trips.isNotEmpty)
                      Recents(
                          max: 1,
                          type: "to",
                          callback: () async {
                            // print('debug: closed');
                          }),
                  ]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
