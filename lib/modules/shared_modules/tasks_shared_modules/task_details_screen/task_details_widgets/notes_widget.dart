import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class NotesWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const NotesWidget(this.label, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsConstants.primaryColor.withOpacity(0.01),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 2.0, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsConstants.primaryColor),
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
        ],
      ),
    );
  }
}
