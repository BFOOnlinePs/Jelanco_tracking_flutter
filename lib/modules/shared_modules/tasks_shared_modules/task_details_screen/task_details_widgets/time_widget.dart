import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';

class TimeWidget extends StatelessWidget {
  final String label;
  final DateTime value;
  final IconData icon;

  const TimeWidget(this.label, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsConstants.primaryColor, width: 0.6),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Background color
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: ColorsConstants.primaryColor),
            SizedBox(height: 5),
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ColorsConstants.primaryColor,
              ),
            ),
            Text(
              MyDateUtils.formatDateTime(value),
              style: TextStyle(color: Colors.grey[800], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
