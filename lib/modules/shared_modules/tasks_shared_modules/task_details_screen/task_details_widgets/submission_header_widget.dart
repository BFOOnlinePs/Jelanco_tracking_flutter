import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';

class SubmissionHeaderWidget extends StatelessWidget {
  final TaskSubmissionModel submissionModel;

  const SubmissionHeaderWidget(this.submissionModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'مقدم بواسطة: ${submissionModel.submitterUser?.name}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: ColorsConstants.secondaryColor),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTaskSubmissionScreen(
                  taskId: submissionModel.tsTaskId!,
                  taskSubmissionModel: submissionModel,
                  isEdit: true,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
