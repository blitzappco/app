import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../..//utils/env.dart';
import 'package:transitway/v2/components/modals/confirm_ticket.dart';
import '../../providers/account_provider.dart';
import '../../providers/route_provider.dart';

class BuyTicket {
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
                height: 190,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 80,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/Images/Bpay.png'))),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
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
                        padding: const EdgeInsets.all(15.0),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final route = Provider.of<RouteProvider>(
                                      context,
                                      listen: false);
                                  route.changeSelectedTicketType('0');
                                  ConfirmTicket.show(context);
                                },
                                child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bilet 60 min',
                                        style: TextStyle(
                                            fontFamily: 'UberMoveMedium',
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '4 RON',
                                        style: TextStyle(
                                            fontFamily: 'UberMoveBold',
                                            fontSize: 20),
                                      )
                                    ]),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final route = Provider.of<RouteProvider>(
                                      context,
                                      listen: false);
                                  route.changeSelectedTicketType('1');
                                  ConfirmTicket.show(context);
                                },
                                child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Abonament o zi',
                                        style: TextStyle(
                                            fontFamily: 'UberMoveMedium',
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '15 RON',
                                        style: TextStyle(
                                            fontFamily: 'UberMoveBold',
                                            fontSize: 20),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
      },
    );
  }
}
