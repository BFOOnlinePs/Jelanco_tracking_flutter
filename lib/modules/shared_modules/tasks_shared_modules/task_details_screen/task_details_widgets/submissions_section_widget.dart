import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/add_comment_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/detail_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class SubmissionsSectionWidget extends StatelessWidget {
  final TaskDetailsCubit taskDetailsCubit;

  const SubmissionsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitleWidget('عمليات التسليم'),
        ...taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions
                ?.map((submission) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.04),
                  border: const Border(
                    right: BorderSide(
                      color: ColorsConstants.secondaryColor,
                      width: 5.0,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubmissionHeaderWidget(submission),
                    ContentWidget(
                      submission.tsContent ?? '',
                      Icons.content_copy,
                      isSubmission: true,
                    ),
                    SubmissionMediaWidget(
                      submission: submission,
                      taskDetailsCubit: taskDetailsCubit,
                    ),
                    const MyVerticalSpacer(),
                    SubmissionTimeWidget(submission: submission),
                    const MyVerticalSpacer(),
                    submission.submissionComments!.isNotEmpty
                        ? CommentsSectionWidget(
                            comments: submission.submissionComments!,
                            // taskDetailsCubit: taskDetailsCubit,
                          )
                        : Container(),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            // This allows the bottom sheet to resize when the keyboard appears
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider.value(
                                value: taskDetailsCubit,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom, // Adjust for keyboard
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AddCommentWidget(
                                          taskId: submission.tsTaskId!,
                                          taskSubmissionId: submission.tsId!,
                                        ),
                                        // SizedBox(height: 20),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     Navigator.pop(context);
                                        //   },
                                        //   child: Text('Close'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).whenComplete(() {
                            // Unfocus when the bottom sheet is dismissed
                            taskDetailsCubit.whenCloseBottomSheet();
                          });

                          Future.delayed(Duration(milliseconds: 100), () {
                            taskDetailsCubit.focusNode.requestFocus();
                          });
                        },
                        child: Text('أكتب تعليق'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ??
            [],
      ],
    );
  }
}
