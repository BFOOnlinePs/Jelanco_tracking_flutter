import 'package:flutter/material.dart';

class MyLoader extends StatelessWidget {
  final Color? color;

  const MyLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
    );
  }
}
