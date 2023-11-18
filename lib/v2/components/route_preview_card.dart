import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/segment.dart';
import '../providers/route_provider.dart';
import './shorthands/shorthand.dart';

class RoutePreviewCard extends StatelessWidget {
  final List<Segment> segments;
  final Map<String, String> meta;
  final int index;

  final Future<void> Function() callback;
  const RoutePreviewCard(
      {required this.segments,
      required this.meta,
      required this.index,
      required this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(builder: (context, route, _) {
      return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta['duration'].toString(),
                  style:
                      const TextStyle(fontFamily: 'UberMoveBold', fontSize: 23),
                ),
                Row(
                  children: [
                    Text(
                      '${meta['leaveAt']}',
                      style: const TextStyle(
                          fontFamily: 'UberMove',
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                    Transform.rotate(
                      angle: 45 * 3.141592653589793 / 180,
                      child: Lottie.network(
                          'https://lottie.host/1e2cd4a1-120e-4f95-8b15-2257bf2e9a1b/j8iPCwLDUL.json',
                          height: 20,
                          width: 20),
                    )
                  ],
                ),
                if (meta['leaveAt'] != "Leave now")
                  const Text(
                    '4 RON',
                    style: TextStyle(
                        fontFamily: 'UberMove',
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Wrap(
                    spacing:
                        0.0, // Adjust the spacing between elements as needed
                    runSpacing: 5.0, // Adjust the run spacing as needed
                    children: segments.map((segment) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Shorthand(
                            isWalk: segment.isWalk,
                            time: segment.time,
                            lineName: segment.lineName,
                            lineType: segment.lineType,
                          ),
                          if (segments.indexOf(segment) < segments.length - 1)
                            const Icon(Icons.arrow_right_rounded),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () async {
                await callback();

                Timer(const Duration(milliseconds: 350), () {
                  route.changePage('route');
                  route.changeRouteIndex(index);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF44D55B),
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Go',
                    style: TextStyle(
                        fontFamily: 'UberMoveBold',
                        color: Colors.white,
                        fontSize: 22),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
