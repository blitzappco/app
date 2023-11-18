import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/account_provider.dart';

class CarbonFootprint {
  static void show(BuildContext context, int distance) {
    // must be multiplied by number of km to get kgs of CO2 saved ;)

    showModalBottomSheet(
      backgroundColor: Colors.teal[100],
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
        final double averageSaveFactor = 0.85;

        return Consumer<AccountProvider>(builder: (context, auth, _) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                color: Colors.transparent,
                height: 400,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.teal[600],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/Images/tree.png'))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Congrats! You saved ${averageSaveFactor * distance} kg of CO2',
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontSize: 20,
                              fontFamily: 'UberMoveBold'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            'Because you chose to travel by public transport you reduced your carbon footprint and you helped fight the climatic changes.',
                            style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 15,
                                fontFamily: 'UberMoveMedium'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
      },
    );
  }
}
