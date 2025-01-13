import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/category_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/show_modal_add_comment_button.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/wrapped_label_value_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class SubmissionsSectionWidget extends StatelessWidget {
  final TaskDetailsCubit taskDetailsCubit;

  const SubmissionsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(padding: const EdgeInsetsDirectional.only(start: 16, top: 6), child: const SectionTitleWidget('عمليات التسليم')),
        ...taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions?.map((submission) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubmissionHeaderWidget(
                          isTaskCancelled: taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!.tStatus == TaskStatusEnum.canceled.statusName,
                          submissionModel: submission,
                          // taskDetailsCubit: taskDetailsCubit,
                        ),
                        ContentWidget(
                          submission.tsContent ?? '',
                          isSubmission: true,
                        ),
                        MediaWidget(
                          attachmentsCategories: submission.submissionAttachmentsCategories!,
                          storagePath: EndPointsConstants.taskSubmissionsStorage,
                        ),
                        submission.submissionCategories!.isNotEmpty
                            ? WrappedLabelValueWidget(
                                'التصنيف', submission.submissionCategories?.map((category) => category.cName).join(', ') ?? '')
                            : Container(),
                        SubmissionTimeWidget(submission: submission),
                        submission.submissionComments!.isNotEmpty
                            ? CommentsSectionWidget(
                                comments: submission.submissionComments!,
                              )
                            : Container(),
                        const SizedBox(
                          height: 6,
                        ),
                        if (SystemPermissions.hasPermission(SystemPermissions.addComment) &&
                            // can't add comment if the task is cancelled
                            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!.tStatus != TaskStatusEnum.canceled.statusName)
                          ShowModalAddCommentButton(
                            taskId: submission.tsTaskId!,
                            submissionId: submission.tsId!,
                          ),
                        const MyVerticalSpacer(),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 5,
                  )
                ],
              );
            }).toList() ??
            [],
      ],
    );
  }
}
