import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubmissionHeaderWidget(
                          submissionModel: submission,
                          taskDetailsCubit: taskDetailsCubit,
                        ),
                        ContentWidget(
                          submission.tsContent ?? '',
                          isSubmission: true,
                        ),
                        SubmissionMediaWidget(
                          submission: submission,
                          taskDetailsCubit: taskDetailsCubit,
                        ),
                        // SubmissionTimeWidget(submission: submission),
                        submission.submissionComments!.isNotEmpty
                            ? CommentsSectionWidget(
                                comments: submission.submissionComments!,
                              )
                            : Container(),
                        SizedBox(
                          height: 6,
                        ),
                        MyTextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                // This allows the bottom sheet to resize when the keyboard appears
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
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
                                            taskSubmissionId:
                                                submission.tsId!,
                                            whenCommentAdded: () {
                                              // call
                                            },
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
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  child: TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0),

                                      hintText: "أضف تعليقاً ...",
                                      // no border
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 3.14 * 1.25,
                                  child: Icon(FontAwesomeIcons.locationArrow),
                                )
                              ],
                            )
                            // Text(
                            //   'أكتب تعليق جديد',
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),

                            ),
                        MyVerticalSpacer(),
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
