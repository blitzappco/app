import 'package:flutter/material.dart';
import '../../utils/env.dart';

class LineShorthand extends StatelessWidget {
  final String lineName;
  const LineShorthand({required this.lineName, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: lineColors[lineName] ?? Colors.black,
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          lineName,
          style: const TextStyle(
              fontFamily: 'UberMoveBold', color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
