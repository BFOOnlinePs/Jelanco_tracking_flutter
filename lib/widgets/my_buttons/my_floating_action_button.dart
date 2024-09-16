import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class MyFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final Function()? onPressed;

  const MyFloatingActionButton(
      {super.key, required this.icon, required this.labelText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        labelText,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      icon: Icon(icon, color: Colors.white),
      backgroundColor: ColorsConstants.primaryColor,
    );
  }
}
