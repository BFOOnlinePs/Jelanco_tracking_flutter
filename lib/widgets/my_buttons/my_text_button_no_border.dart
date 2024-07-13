import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyTextButtonNoBorder extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButtonNoBorder({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      // style: ButtonStyle(
      //
      // ),
    );
  }
}
