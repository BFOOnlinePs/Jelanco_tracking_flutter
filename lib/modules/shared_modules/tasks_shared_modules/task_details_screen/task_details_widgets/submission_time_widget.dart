import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';

class SubmissionTimeWidget extends StatelessWidget {
  final TaskSubmissionModel submission;

  const SubmissionTimeWidget({
    super.key,
    required this.submission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          submission.tsActualStartTime != null
              ? Expanded(
                  child: TimeWidget('وقت البدء', submission.tsActualStartTime!,
                      Icons.access_time),
                )
              : Container(),
          submission.tsActualStartTime != null &&
                  submission.tsActualEndTime != null
              ? const SizedBox(width: 10)
              : Container(),
          submission.tsActualEndTime != null
              ? Expanded(
                  child: TimeWidget('وقت الإنتهاء', submission.tsActualEndTime!,
                      Icons.access_time_outlined),
                )
              : Container(),
        ],
      ),
    );
  }
}
