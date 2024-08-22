import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class MyAuthElevatedButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyAuthElevatedButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: child,
        ),

        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(ColorsConstants.primaryColor),
        ),
        // style: ButtonStyle(
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
