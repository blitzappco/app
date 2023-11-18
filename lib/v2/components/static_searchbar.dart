import 'package:flutter/material.dart';
import '../utils/env.dart';
import 'modals/search_modal.dart';

class StaticSearchbar extends StatefulWidget {
  const StaticSearchbar({super.key});

  @override
  State<StaticSearchbar> createState() => _StaticSearchbarState();
}

class _StaticSearchbarState extends State<StaticSearchbar> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          SearchModal.show(context, "to");
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9), color: lightGrey),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: darkGrey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Unde mergem?',
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: 'UberMoveMedium',
                      color: darkGrey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
