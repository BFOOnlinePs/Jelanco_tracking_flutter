import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';


class MyTextButtonForCard extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButtonForCard({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (Set<WidgetState> states) {
            return const BorderSide(
              color: ColorsConstants.primaryColor,
              width: 1,
            );
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ButtonSizeConstants.borderRadius),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
        // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        //       (Set<MaterialState> states) {
        //     return null; // No background color
        //   },
        // ),
      ),
      child: child,
    );
  }
}
