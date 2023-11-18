import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../models/ticket.dart';
import '../../providers/balance_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/tickets_provider.dart';
import '../../utils/env.dart';
import 'dart:async';

class ExtendedTicketModal {
  static void show(BuildContext context, Ticket ticket) {
    final remainingTimeStream = StreamController<String>();

    // Calculate the initial remaining time
    String initialRemainingTime =
        calculateRemainingTime(ticket.expiresAt ?? DateTime.now());
    remainingTimeStream.add(initialRemainingTime);

    // Set up a timer to update the remaining time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      String remainingTime =
          calculateRemainingTime(ticket.expiresAt ?? DateTime.now());
      remainingTimeStream.add(remainingTime);
    });

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
        return StreamBuilder<String>(
          stream: remainingTimeStream.stream,
          builder: (context, snapshot) {
            final remainingTime = snapshot.data ?? 'Expired'; // Default value

            return Consumer<AccountProvider>(
              builder: (context, auth, _) {
                return Consumer<BalanceProvider>(
                  builder: (context, balance, _) {
                    return Consumer<TicketsProvider>(
                      builder: (context, tickets, _) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${ticket.name}',
                                          style: const TextStyle(
                                            fontFamily: "UberMoveBold",
                                            fontSize: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: lightGrey,
                                      ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: SfBarcodeGenerator(
                                            value: ticket.id,
                                            symbology: QRCode(),
                                          ),
                                        ),
                                      ),
                                      // Add space between QR code and remaining time
                                      Container(
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color.fromRGBO(
                                              210, 210, 243, 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.timelapse_outlined,
                                                color: Color.fromARGB(
                                                    255, 89, 44, 235),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                remainingTime,
                                                style: const TextStyle(
                                                  fontFamily: 'UberMoveMedium',
                                                  color: Color.fromARGB(
                                                      255, 89, 44, 235),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  static String calculateRemainingTime(DateTime expiresAt) {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return 'Expired';
    }

    final difference = expiresAt.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    if (days > 0) {
      return '$days days';
    } else if (hours > 0) {
      return '$hours hours $minutes min';
    } else if (minutes > 0) {
      return '$minutes min $seconds sec';
    } else {
      return '$seconds sec';
    }
  }
}
