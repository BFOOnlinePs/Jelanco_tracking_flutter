import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';

class TaskToSubmitCardWidget extends StatelessWidget {
  final TaskModel task;

  const TaskToSubmitCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationServices.navigateTo(
            context, TaskDetailsScreen(taskId: task.tId!));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          gradient: ColorsConstants.myLinearGradient,
          borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
        ),
        child: Card(
          color: Colors.transparent,
          // Make the Card background transparent
          elevation: 4.0,
          // Add shadow to the Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            // Add padding inside the Card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '> بواسطة: ${task.addedByUser?.name ?? ''}',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
                Text(
                  task.tContent ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
