import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/modals/extended_ticket_modal.dart';

import '../models/ticket.dart';

class TicketItem extends StatelessWidget {
  final Ticket ticket;
  const TicketItem({
    required this.ticket,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(ticket.createdAt ?? DateTime.now());

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ExtendedTicketModal.show(context, ticket);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.name ?? '',
                  style:
                      const TextStyle(fontFamily: 'UberMoveBold', fontSize: 20),
                ),
                Text(
                  '${ticket.price} RON',
                  style: const TextStyle(
                      fontFamily: 'UberMoveMedium', fontSize: 20),
                )
              ],
            ),
            Text(
              formattedDate,
              style:
                  const TextStyle(fontFamily: 'UberMoveMedium', fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime ticketDate) {
    DateTime now = DateTime.now().toLocal();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (ticketDate.isAfter(today)) {
      // Ticket bought today, show HH:MM
      return 'Today, ${DateFormat.Hm().format(ticketDate)}';
    } else if (ticketDate.isAfter(yesterday)) {
      // Ticket bought yesterday, show yesterday
      return 'Yesterday, ${DateFormat.Hm().format(ticketDate)}';
    } else {
      // Ticket bought earlier than yesterday, show DD MMM YY
      return DateFormat('dd MMMM').format(ticketDate);
    }
  }
}
