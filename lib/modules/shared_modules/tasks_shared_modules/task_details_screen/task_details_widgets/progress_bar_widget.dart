import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/enums/task_and_submission_status_enum.dart';
import 'package:jelanco_tracking_system/widgets/my_progress_bar/my_progress_bar.dart';

class ProgressBarWidget extends StatelessWidget {
  final TaskAndSubmissionStatusEnum currentStatusEnum;

  const ProgressBarWidget({super.key, required this.currentStatusEnum});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 10, bottom: 4),
      child: MyProgressBar(
        currentStatus: currentStatusEnum,
        segments: currentStatusEnum == TaskAndSubmissionStatusEnum.canceled ? [
          TaskAndSubmissionStatusEnum.canceled,
        ] : [
          TaskAndSubmissionStatusEnum.active.copyWith(percent: 0.1),
          TaskAndSubmissionStatusEnum.inProgress.copyWith(percent: 0.4),
          TaskAndSubmissionStatusEnum.completed.copyWith(percent: 0.15),
          TaskAndSubmissionStatusEnum.evaluated.copyWith(percent: 0.25),
        ],
      ),
    );
  }
}
