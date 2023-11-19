import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/modals/buy_ticket_modal.dart';
import '../../components/modals/extended_ticket_modal.dart';
import '../../maps/map_controller.dart';
import '../../providers/account_provider.dart';
import '../../providers/route_provider.dart';
import '../../utils/check_expiry.dart';
import '../navigation_card.dart';
import 'carbon_footprint.dart';
import 'confirm_exit_modal.dart';

class RouteModal extends StatefulWidget {
  final GoogleMapController mapController;
  const RouteModal({required this.mapController, super.key});

  @override
  State<RouteModal> createState() => _RouteModalState();
}

class _RouteModalState extends State<RouteModal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final account = Provider.of<AccountProvider>(context, listen: false);
      final route = Provider.of<RouteProvider>(context, listen: false);

      setNavMode(
          widget.mapController, LatLng(route.from.lat, route.from.long), 0.0);

      await route.getLastTicket(account.token);
    });
  }

  double distance = 10;

  @override
  Widget build(BuildContext context) {
    Geolocator.getPositionStream().listen((Position position) async {
      final route = Provider.of<RouteProvider>(context, listen: false);
      if (route.page == 'route') {
        setNavMode(
          widget.mapController,
          LatLng(position.latitude, position.longitude),
          position.heading,
        );
      }
      route.setPosition(position);
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      final route = Provider.of<RouteProvider>(context, listen: false);

      double distance = Geolocator.distanceBetween(
          route.position?.latitude ?? 0.0,
          route.position?.longitude ?? 0.0,
          route.to.lat,
          route.to.long);

      if (distance < 5 && route.cfShown) {
        CarbonFootprint.show(context, 2);
        route.changeCFShown(false);
      }
    });

    return Consumer<RouteProvider>(builder: (context, route, _) {
      return DraggableScrollableSheet(
          minChildSize: 0.4,
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 247, 247),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              route.to.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'UberMoveBold', fontSize: 23),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          route.to.address,
                          style: const TextStyle(
                            fontFamily: 'UberMoveMedium',
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ConfirmExit.show(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.purple[100]),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: Colors.purple[900],
                                        size: 20,
                                      ),
                                      Text(
                                        'Exit Navigation',
                                        style: TextStyle(
                                            fontFamily: 'UberMoveBold',
                                            fontSize: 15,
                                            color: Colors.purple[900]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (checkExpiry(
                                route.ticket.expiresAt ?? DateTime.now()))
                              GestureDetector(
                                onTap: () => BuyTicket.show(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.purple[100]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.receipt_long_rounded,
                                          color: Colors.purple[900],
                                          size: 20,
                                        ),
                                        Text(
                                          'Buy ticket',
                                          style: TextStyle(
                                              fontFamily: 'UberMoveBold',
                                              fontSize: 15,
                                              color: Colors.purple[900]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              GestureDetector(
                                  onTap: () => ExtendedTicketModal.show(
                                      context, route.ticket),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.purple[100]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.receipt_long_rounded,
                                            color: Colors.purple[900],
                                            size: 20,
                                          ),
                                          Text(
                                            'Ticket',
                                            style: TextStyle(
                                                fontFamily: 'UberMoveBold',
                                                fontSize: 15,
                                                color: Colors.purple[900]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: route.stepsList[route.routeIndex]
                            .map((step) => NavigationCard(step: step))
                            .toList(),
                      )
                    ]),
              ),
            );
          });
    });
  }
}
