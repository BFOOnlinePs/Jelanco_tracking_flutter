import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class WrappedLabelValueWidget extends StatelessWidget {
  final String label;
  final String value;

  const WrappedLabelValueWidget(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded( // Ensures text can expand and wrap within available space
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
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
