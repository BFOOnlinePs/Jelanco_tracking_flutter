import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class AssignedToWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const AssignedToWidget(this.label, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon(icon, color: ColorsConstants.primaryColor),
        // SizedBox(width: 10),
        Expanded( // Ensures text can expand and wrap within available space
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: ColorsConstants.primaryColor,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.visible, // Ensures it wraps instead of overflowing
          ),
        ),
      ],
    );
    

  }
}
