import 'package:flutter/material.dart';

class MyTextButtonScratch extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButtonScratch({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // Remove button's default padding and border effects
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.zero, // Ensure no padding around the child
          child: child,
        ),
      ),
    );
  }
}
