import 'package:flutter/material.dart';

class MyScreenTitleWidget extends StatelessWidget {
  final String title;

  const MyScreenTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
