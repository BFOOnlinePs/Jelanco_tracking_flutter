import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/detail_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class SubmissionsSectionWidget extends StatelessWidget {
  final TaskDetailsCubit taskDetailsCubit;
  const SubmissionsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget('Submissions'),
        ...taskDetailsCubit
            .getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions
            ?.map((submission) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border(
                left: BorderSide(
                  color: ColorsConstants.secondaryColor,
                  width: 5.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubmissionHeaderWidget(submission),
                ContentWidget('Content', submission.tsContent ?? '',
                    Icons.content_copy,
                    isSubmission: true),

                DetailRowWidget(
                    'File', submission.tsFile ?? '', Icons.attach_file),

                MyVerticalSpacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    submission.tsActualStartTime != null
                        ? Expanded(
                      child: TimeWidget(
                          'Actual Start Time',
                          submission.tsActualStartTime!,
                          Icons.access_time),
                    )
                        : Container(),
                    submission.tsActualStartTime != null &&
                        submission.tsActualEndTime != null
                        ? SizedBox(width: 10)
                        : Container(),
                    submission.tsActualEndTime != null
                        ? Expanded(
                      child: TimeWidget(
                          'Actual End Time',
                          submission.tsActualEndTime!,
                          Icons.access_time_outlined),
                    )
                        : Container(),
                  ],
                ),

                // _buildStatusRow('Status', submission.status, Icons.info),
                MyVerticalSpacer(),
                submission.submissionComments!.isNotEmpty
                    ? CommentsSectionWidget(submission.submissionComments!)
                    : Container(),
              ],
            ),
          );
        }).toList() ??
            [],
      ],
    );
  }
}
