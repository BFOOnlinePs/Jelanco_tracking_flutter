import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class DetailRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const DetailRowWidget(this.label, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ColorsConstants.primaryColor),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsConstants.primaryColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
