import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../maps/place.dart';
import '../../providers/route_provider.dart';
import '../../providers/trips_provider.dart';
import '../../utils/env.dart';
import 'place_item.dart';

class Recents extends StatefulWidget {
  final int max;
  final String type;
  final Future<void> Function() callback;
  const Recents(
      {required this.max,
      required this.type,
      required this.callback,
      super.key});

  @override
  State<Recents> createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return Consumer<TripsProvider>(builder: (context, trips, _) {
        return Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recente',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'UberMoveMedium',
                  color: darkGrey,
                ),
              ),
              // Text(
              //   'Mai multe',
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontFamily: 'UberMoveMedium',
              //     color: Colors.blue,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 15),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(
                    color: lightGrey,
                  ),
                );
              },
              shrinkWrap: true,
              itemCount: trips.trips.length > widget.max
                  ? widget.max
                  : trips.trips.length,
              itemBuilder: (context, index) {
                final p = Place(
                    address: trips.trips[index].address,
                    name: trips.trips[index].name,
                    type: '');
                return PlaceItem(
                  place: p,
                  callback: () async {
                    await widget.callback();
                    await route.changePage('preview');
                    route.setLoading(true);
                    if (widget.type == 'from') {
                      await route.selectFrom(p);
                    } else if (widget.type == 'to') {
                      await route.selectTo(p);
                    }

                    await route.loadData();

                    route.setLoading(false);
                  },
                );
              },
            ),
          ),
        ]);
      });
    });
  }
}
