import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final bool isWidthFull;

  const MyElevatedButton({
    required this.onPressed,
    required this.child,
    this.isWidthFull = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWidthFull ? double.infinity : null,
      // decoration: BoxDecoration(
      //   gradient: ColorsConstants.myLinearGradient
      // ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          // padding: EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(0.0),

          child: Ink(
            decoration: BoxDecoration(
              // gradient: ColorsConstants.myLinearGradient,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0),
                // constraints:
                //     const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                child: child),
          ),
        ),
        // style: ElevatedButton.styleFrom(
        //   minimumSize: Size(0, 0),
        //     backgroundColor: Colors.transparent,
        //     shadowColor: Colors.transparent),
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: Colors.transparent, // Make button transparent
        //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20.0),
        //   ),
        // ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(ColorsConstants.primaryColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(ButtonSizeConstants.borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
