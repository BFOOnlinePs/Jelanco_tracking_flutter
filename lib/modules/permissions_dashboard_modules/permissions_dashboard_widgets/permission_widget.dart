import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';

class PermissionWidget extends StatelessWidget {
  final String permissionText;
  final Function onEditTap;

  PermissionWidget({
    required this.permissionText,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        title: Text(
          permissionText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => onEditTap(),
        ),
      ),
    );
  }
}
