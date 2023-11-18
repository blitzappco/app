import 'package:flutter/material.dart';
import 'package:transitway/v2/components/modals/carbon_footprint.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            CarbonFootprint.show(context, 22);
          },
          child: Container(
            color: Colors.amber,
            height: 90,
            width: 200,
          ),
        ),
      ),
    );
  }
}
