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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsConstants.primaryColor, width: 0.6),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: ColorsConstants.primaryColor, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: ColorsConstants.primaryColor,
                ),
              ),
              Text(
                MyDateUtils.formatDateTime(value),
                style: TextStyle(color: Colors.grey[800], fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
