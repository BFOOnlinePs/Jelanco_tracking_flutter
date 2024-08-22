import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class TaskToSubmitCardWidget extends StatelessWidget {
  final TaskModel task;
  const TaskToSubmitCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        gradient: ColorsConstants.myLinearGradient,
        borderRadius: BorderRadius.circular(
            CardSizeConstants.cardRadius),
      ),
      child: Card(
        color: Colors.transparent,
        // Make the Card background transparent
        elevation: 4.0,
        // Add shadow to the Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              CardSizeConstants.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          // Add padding inside the Card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '> ${task.addedByUser?.name ?? ''}',
                style:
                TextStyle(color: Colors.orangeAccent),
              ),
              Text(
                task.tContent ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
