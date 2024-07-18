import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class SubmissionHeaderWidget extends StatelessWidget {
  final TaskSubmissionModel submission;
  const SubmissionHeaderWidget(this.submission, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Submitted By: ${submission.submitterUser?.name}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: ColorsConstants.secondaryColor),
          onPressed: () {
            // Add action for editing the submission
          },
        ),
      ],
    );
  }
}
