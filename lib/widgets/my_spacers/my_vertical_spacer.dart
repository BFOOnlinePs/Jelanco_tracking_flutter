import 'package:flutter/material.dart';

class MyVerticalSpacer extends StatelessWidget {
  final double? height;

  const MyVerticalSpacer({
    super.key,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
