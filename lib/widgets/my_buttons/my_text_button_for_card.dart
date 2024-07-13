import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';


class MyTextButtonForCard extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButtonForCard({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            return BorderSide(
              color: ColorsConstants.primaryColor,
              width: 1,
            );
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ButtonSizeConstants.borderRadius),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        //       (Set<MaterialState> states) {
        //     return null; // No background color
        //   },
        // ),
      ),
    );
  }
}
