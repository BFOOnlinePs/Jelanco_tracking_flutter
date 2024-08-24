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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: ColorsConstants.primaryColor),
            SizedBox(width: 10),
            Text(
              '$label: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ColorsConstants.primaryColor),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 34),
            Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
