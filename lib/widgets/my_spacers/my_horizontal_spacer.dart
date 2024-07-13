import 'package:flutter/material.dart';

class MyHorizontalSpacer extends StatelessWidget {
  final double? width;

  const MyHorizontalSpacer({
    super.key,
    this.width = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
