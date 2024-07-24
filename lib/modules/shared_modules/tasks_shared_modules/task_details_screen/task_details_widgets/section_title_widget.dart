import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final TaskStatusEnum? status;
  final IconData? statusIcon;

  const SectionTitleWidget(this.title,
      {super.key, this.status, this.statusIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.primaryColor,
            ),
          ),
          status != null
              ? Row(
                  children: [
                    Icon(statusIcon, color: status?.statusColor, size: 18),
                    SizedBox(width: 6),
                    Text(
                      status?.statusEn ?? '',
                      style:
                          TextStyle(color: status?.statusColor, fontSize: 16),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
