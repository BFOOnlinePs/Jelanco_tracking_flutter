import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/show_modal_add_comment_button.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskSubmissionDetailsScreen extends StatelessWidget {
  final int submissionId;

  const TaskSubmissionDetailsScreen({super.key, required this.submissionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'تفاصيل التسليم',
      ),
      body: BlocProvider(
        create: (context) => TaskSubmissionDetailsCubit()
          ..getTaskSubmissionWithTaskAndComments(submissionId: submissionId),
        child: BlocConsumer<TaskSubmissionDetailsCubit,
            TaskSubmissionDetailsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            TaskSubmissionDetailsCubit taskSubmissionDetailsCubit =
                TaskSubmissionDetailsCubit.get(context);

            return taskSubmissionDetailsCubit
                        .getTaskSubmissionWithTaskAndCommentsModel !=
                    null
                ? Column(
                    children: [
                      taskSubmissionDetailsCubit
                                  .getTaskSubmissionWithTaskAndCommentsModel
                                  ?.taskSubmission
                                  ?.taskDetails !=
                              null
                          ? TaskDetailsSectionWidget(
                              taskModel: taskSubmissionDetailsCubit
                                  .getTaskSubmissionWithTaskAndCommentsModel!
                                  .taskSubmission!
                                  .taskDetails!)
                          : Container(),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SubmissionHeaderWidget(
                              submissionModel: taskSubmissionDetailsCubit
                                  .getTaskSubmissionWithTaskAndCommentsModel!
                                  .taskSubmission!,
                            ),
                            ContentWidget(
                              taskSubmissionDetailsCubit
                                      .getTaskSubmissionWithTaskAndCommentsModel!
                                      .taskSubmission!
                                      .tsContent ??
                                  '',
                              isSubmission: true,
                            ),
                            SubmissionMediaWidget(
                              submission: taskSubmissionDetailsCubit
                                  .getTaskSubmissionWithTaskAndCommentsModel!
                                  .taskSubmission!,
                            ),
                            // SubmissionTimeWidget(submission: submission),
                            taskSubmissionDetailsCubit
                                    .getTaskSubmissionWithTaskAndCommentsModel!
                                    .taskSubmission!
                                    .submissionComments!
                                    .isNotEmpty
                                ? CommentsSectionWidget(
                                    comments: taskSubmissionDetailsCubit
                                        .getTaskSubmissionWithTaskAndCommentsModel!
                                        .taskSubmission!
                                        .submissionComments!,
                                  )
                                : Container(),
                            SizedBox(
                              height: 6,
                            ),
                            ShowModalAddCommentButton(
                                taskId: taskSubmissionDetailsCubit
                                    .getTaskSubmissionWithTaskAndCommentsModel!
                                    .taskSubmission!
                                    .tsTaskId!,
                                submissionId: submissionId),
                          ],
                        ),
                      ),
                      MyVerticalSpacer(),
                    ],
                  )
                : Container();
          },
        ),
      ),
    );
    // return TaskDetailsSectionWidget(
    //   taskModel: taskDetailsCubit
    //       .getTaskWithSubmissionsAndCommentsModel!
    //       .task!,
    // );
  }
}