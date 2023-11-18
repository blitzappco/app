import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/step.dart';
import '../providers/route_provider.dart';
import '../utils/env.dart';
import 'shorthands/line_shorthand.dart';

class NavigationCard extends StatelessWidget {
  // final String cardType;

  final StepModel step;

  const NavigationCard({required this.step, super.key});

  @override
  Widget build(BuildContext context) {
    switch (step.type) {
      case 'walking':
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.directions_walk_rounded,
                    size: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Walk to the next step',
                      style:
                          TextStyle(fontSize: 25, fontFamily: "UberMoveBold"),
                    ),
                    Text(
                      '${step.distance}, aprox. ${step.time}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "UberMoveMedium",
                          color: darkGrey),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      case 'getIn':
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset(
                  'assets/icons/stpt.png',
                  width: 35,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Get in at ${step.fromStation}',
                        style: const TextStyle(
                            fontSize: 25, fontFamily: "UberMoveBold"),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      // LineShorthand(lineName: '35B'),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      // Text(
                      //   'la Marasti',
                      //   style:
                      //       TextStyle(fontSize: 25, fontFamily: "UberMoveBold"),
                      // )
                    ],
                  ),
                  Row(
                    children: [
                      LineShorthand(lineName: step.line),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        step.headsign,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "UberMoveMedium",
                            color: darkGrey),
                      ),
                    ],
                  ),
                  const Text(
                    '4 lei contactless',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "UberMoveMedium",
                        color: darkGrey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Departure at ${step.time}', // pleace la
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "UberMoveMedium",
                        ),
                      ),
                      Transform.rotate(
                        angle: 45 * 3.141592653589793 / 180,
                        child: Lottie.network(
                            'https://lottie.host/1e2cd4a1-120e-4f95-8b15-2257bf2e9a1b/j8iPCwLDUL.json',
                            height: 30,
                            width: 30),
                      )
                    ],
                  ),
                ],
              ),
            ]),
          ),
        );
      case 'getOut':
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 35,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get out at ${step.toStation}',
                    style: const TextStyle(
                        fontSize: 25, fontFamily: "UberMoveBold"),
                  ),
                  Text(
                    'After ${step.numStops} stops',
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "UberMoveMedium",
                        color: darkGrey),
                  ),
                ],
              ),
            ]),
          ),
        );
      case 'destination':
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 5),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: blitzPurple),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.place,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Consumer<RouteProvider>(builder: (context, route, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Destination',
                        style:
                            TextStyle(fontSize: 25, fontFamily: "UberMoveBold"),
                      ),
                      Text(
                        route.to.name,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "UberMoveMedium",
                            color: darkGrey),
                      ),
                      Text(
                        route.to.address,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "UberMoveMedium",
                            color: darkGrey),
                      )
                    ],
                  );
                })
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
