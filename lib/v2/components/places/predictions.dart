import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trip.dart';
import '../../providers/account_provider.dart';
import '../../providers/route_provider.dart';
import '../../providers/trips_provider.dart';
import '../../utils/env.dart';
import 'place_item.dart';

class Predictions extends StatefulWidget {
  final String type;
  final Future<void> Function() callback;

  const Predictions({required this.type, required this.callback, super.key});

  @override
  State<Predictions> createState() => _PredictionsState();
}

class _PredictionsState extends State<Predictions> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, account, _) {
      return Consumer<TripsProvider>(builder: (context, trips, _) {
        return Consumer<RouteProvider>(builder: (context, route, _) {
          return Column(children: [
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
                itemCount:
                    route.predictions.length > 3 ? 3 : route.predictions.length,
                itemBuilder: (context, index) {
                  final p = route.predictions[index];
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

                        trips.addTrip(
                          account.token,
                          Trip(
                              accountID: account.account.id ?? '',
                              name: route.to.name,
                              address: route.to.address,
                              type: 'comm',
                              latitude: route.to.lat,
                              longitude: route.to.long,
                              datetime: DateTime.now()),
                        );
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
    });
  }
}
