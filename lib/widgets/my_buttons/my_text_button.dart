import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class MyTextButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;

  const MyTextButton({super.key, required this.onPressed, required this.child});

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
            borderRadius: BorderRadius.circular(
                ButtonSizeConstants.borderRadius), // Border radius
          ),
        ),
        // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        //       (Set<MaterialState> states) {
        //     return null; // No background color
        //   },
        // ),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white), // Set white background within border

      ),
      child: child,
    );
  }
}
