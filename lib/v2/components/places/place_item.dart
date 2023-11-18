import 'package:flutter/material.dart';
import '../../utils/env.dart';

import '../../maps/place.dart';

class PlaceItem extends StatelessWidget {
  final Place place;
  final void Function() callback;
  const PlaceItem({
    required this.place,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: transitwayPurple),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.place,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style:
                      const TextStyle(fontSize: 18, fontFamily: 'UberMoveBold'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  place.address,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'UberMoveMedium',
                    color: darkGrey,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
