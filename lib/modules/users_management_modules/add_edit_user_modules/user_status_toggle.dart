import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/enums/user_status_enum.dart';

class UserStatusToggle extends StatelessWidget {
  final UserStatusEnum status;
  final ValueChanged<bool> onStatusChanged;

  const UserStatusToggle({super.key, required this.status, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          status.statusNameAr,
          style: const TextStyle(
            // color: status.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
        Switch(
          value: status.isActive,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.red.shade100,
          activeTrackColor: Colors.green.shade100,
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}
