import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../components/ticket_item.dart';
import '../../components/modals/tickets_modal.dart';
import '../../pages/topup.dart';
import './confirm_signout_modal.dart';
import '../../providers/balance_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/tickets_provider.dart';
import '../../utils/env.dart';

class ProfileModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9), topRight: Radius.circular(9))),
        builder: (BuildContext context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final account =
                Provider.of<AccountProvider>(context, listen: false);
            final tickets =
                Provider.of<TicketsProvider>(context, listen: false);

            final balance =
                Provider.of<BalanceProvider>(context, listen: false);

            tickets.getTickets(account.token);

            balance.getBalance(account.token);
          });

          List<double> heights = [201, 301, 351, 401];

          return Consumer<AccountProvider>(builder: (context, auth, _) {
            return Consumer<BalanceProvider>(builder: (context, balance, _) {
              return Consumer<TicketsProvider>(builder: (context, tickets, _) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: heights[
                        tickets.list.length > 3 ? 3 : tickets.list.length],
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: .3,
                                          blurRadius: 200,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                      image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/Images/logoa.png')),
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  height: 45,
                                  width: 45,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${auth.account.firstName} ${auth.account.lastName}',
                                      style: const TextStyle(
                                        fontFamily: "UberMoveBold",
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      auth.account.phone ?? '',
                                      style: const TextStyle(
                                        fontFamily: "UberMoveMedium",
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
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
                          height: 10,
                        ),
                        Container(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Balance',
                                        style: TextStyle(
                                            fontFamily: "UberMoveMedium",
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 43, 43, 43)),
                                      ),
                                      Text(
                                        '${balance.value} RON',
                                        style: const TextStyle(
                                          fontFamily: "UberMoveBold",
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Topup()),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 8),
                                        child: Text(
                                          'Top-up',
                                          style: TextStyle(
                                              fontFamily: "UberMoveMedium",
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (tickets.list.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Bought tickets',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'UberMoveMedium',
                                    color: darkGrey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  TicketsModal.show(context);
                                },
                                child: const Text(
                                  'More',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'UberMoveMedium',
                                      color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        if (tickets.list.isNotEmpty)
                          const SizedBox(
                            height: 15,
                          ),
                        if (tickets.list.isNotEmpty)
                          Container(
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  removeBottom: true,
                                  child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final item = tickets.list[index];
                                        return TicketItem(ticket: item);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.5),
                                          child: Divider(),
                                        );
                                      },
                                      itemCount: tickets.list.length > 3
                                          ? 3
                                          : tickets.list.length),
                                ),
                              )),

                        const SizedBox(
                          height: 20,
                        ),

                        //disconnect button
                        GestureDetector(
                          onTap: () {
                            ConfirmSignOut.show(context);
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
                );
              });
            });
          });
        });
  }
}
