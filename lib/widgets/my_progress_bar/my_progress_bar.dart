import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/enums/task_and_submission_status_enum.dart';

class MyProgressBar extends StatelessWidget {
  final TaskAndSubmissionStatusEnum currentStatus;
  final List<TaskAndSubmissionStatusEnum> segments;

  const MyProgressBar({
    super.key,
    required this.currentStatus,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: segments.map((segment) {
            return Expanded(
              flex: (segment.percent * 100).toInt(),
              child: Container(
                height: 4,
                margin: const EdgeInsetsDirectional.only(end: 1),
                color: currentStatus.order < segment.order ? Colors.grey : segment.statusColor,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: segments.map((segment) {
            return Expanded(
              flex: (segment.percent * 100).toInt(),
              child: Center(
                child: Text(
                  segment.statusAr,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
