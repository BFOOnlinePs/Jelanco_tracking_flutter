import 'package:flutter/material.dart';


class MyTextButtonNoBorder extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButtonNoBorder({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,

      // style: ButtonStyle(
      //   padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero), // Remove all padding
      // ),
    );
  }
}
