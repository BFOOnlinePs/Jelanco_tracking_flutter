import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class CategoryRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const CategoryRowWidget(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.category, color: ColorsConstants.primaryColor),
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
