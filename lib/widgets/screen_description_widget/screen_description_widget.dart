import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';

class ScreenDescriptionWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String description;

  ScreenDescriptionWidget(
      {required this.title, required this.iconData, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
