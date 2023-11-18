import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../utils/env.dart';
import '../../providers/account_provider.dart';
import '../../providers/route_provider.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import 'extended_ticket_modal.dart';

class ConfirmTicket {
  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9),
          topRight: Radius.circular(9),
        ),
      ),
      builder: (BuildContext context) {
        // Schedule the focus request after the bottom sheet is built

        return Consumer<RouteProvider>(builder: (context, route, _) {
          return Consumer<AccountProvider>(builder: (context, auth, _) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  color: Colors.transparent,
                  height: 250,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Confirm",
                                style: TextStyle(
                                    fontSize: 28, fontFamily: 'UberMoveBold'),
                              ),
                              Text(
                                "your purchase",
                                style: TextStyle(
                                    fontSize: 28, fontFamily: 'UberMoveBold'),
                              ),
                            ],
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: lightGrey),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.close,
                                  color: darkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: .3,
                              blurRadius: 200,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      route.selectedTicketType == '0'
                                          ? 'Bilet 60 min'
                                          : 'Abonament 1 zi',
                                      style: const TextStyle(
                                          fontFamily: 'UberMoveBold',
                                          fontSize: 20),
                                    ),
                                    Text(
                                      route.selectedTicketType == '0'
                                          ? '4 RON'
                                          : '15 RON',
                                      style: const TextStyle(
                                          fontFamily: 'UberMoveMedium',
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                                const Text(
                                  'STPT Timisoara',
                                  style: TextStyle(
                                      fontFamily: 'UberMoveMedium',
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (!route.showAnimation)
                        GestureDetector(
                          onTap: () async {
                            final account = Provider.of<AccountProvider>(
                                context,
                                listen: false);
                            await route.buyTicket(account.token);

                            if (route.errorMessage == '') {
                              await route.changeShowAnimation(true);

                              Timer(const Duration(milliseconds: 100),
                                  () async {
                                await route.changeRunAnimation(true);

                                Timer(const Duration(milliseconds: 200),
                                    () async {
                                  await HapticFeedback.heavyImpact();

                                  final player = AudioPlayer();
                                  await player.setVolume(0.5);
                                  await player.play(AssetSource('clink.mp3'));
                                });
                              });
                            }

                            Timer(const Duration(milliseconds: 1300), () async {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              await route.changeShowAnimation(false);
                              await route.changeRunAnimation(false);

                              ExtendedTicketModal.show(
                                context,
                                route.ticket,
                              );
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  route.loading
                                      ? 'Processing...'
                                      : 'Place order',
                                  style: const TextStyle(
                                      color: Colors.purple,
                                      fontSize: 20,
                                      fontFamily: 'UberMoveMedium'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      //Pentru animatie
                      if (route.showAnimation)
                        MSHCheckbox(
                          size: 40,
                          value: route.runAnimation,
                          colorConfig:
                              MSHColorConfig.fromCheckedUncheckedDisabled(
                            checkedColor: Colors.purple,
                          ),
                          style: MSHCheckboxStyle.stroke,
                          onChanged: (selected) {},
                        ),
                    ],
                  )),
            );
          });
        });
      },
    );
  }
}
