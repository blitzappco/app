import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transitway/v2/pages/onboarding/onboarding.dart';
import '../../providers/account_provider.dart';

class ConfirmSignOut {
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

        return Consumer<AccountProvider>(builder: (context, auth, _) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Colors.transparent,
              height: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Are you sure you want to disconnect?',
                    style:
                        TextStyle(fontFamily: 'UberMoveMedium', fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: .3,
                                    blurRadius: 200,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'UberMoveMedium',
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            auth.logout();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Onboarding()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: .3,
                                    blurRadius: 200,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign out',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'UberMoveMedium',
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
