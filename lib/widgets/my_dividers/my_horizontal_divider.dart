import 'package:flutter/material.dart';

class MyHorizontalDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double indent;
  final double endIndent;
  final double topMargin;
  final double bottomMargin;

  const MyHorizontalDivider({
    super.key,
    this.height = 1.0,
    this.color = Colors.grey,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(left: indent, right: endIndent, top: topMargin, bottom: bottomMargin),
      color: color,
      width: double.infinity,
    );
  }
}
