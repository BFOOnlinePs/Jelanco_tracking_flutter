import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';

class SubmissionTaskWidget extends StatelessWidget {
  final String taskContent;
  final int taskId;

  const SubmissionTaskWidget(
      {super.key, required this.taskContent, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationServices.navigateTo(
            context, TaskDetailsScreen(taskId: taskId));
      },
      child: Container(
        width: double.infinity,
        color: Colors.grey[300],
        margin: const EdgeInsets.only(top: 2),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskContent,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
