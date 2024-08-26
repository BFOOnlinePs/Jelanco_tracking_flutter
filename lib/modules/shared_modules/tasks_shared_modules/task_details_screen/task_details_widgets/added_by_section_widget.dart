import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';

class AddedBySectionWidget extends StatelessWidget {
  final String addedByName;
  final TaskStatusEnum? status;
  final IconData? statusIcon;

  const AddedBySectionWidget(this.addedByName,
      {super.key, this.status, this.statusIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تكليف بواسطة: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                addedByName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstants.primaryColor,
                ),
              ),
            ],
          ),
          status != null
              ? Row(
                  children: [
                    Icon(statusIcon, color: status?.statusColor, size: 18),
                    SizedBox(width: 6),
                    Text(
                      status?.statusAr ?? '',
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
