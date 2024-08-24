import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/submission_comments_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/assigned_to_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/category_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_planed_time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class HomeUserSubmissionsWidget extends StatelessWidget {
  final HomeCubit homeCubit;

  HomeUserSubmissionsWidget({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: homeCubit.getUserSubmissionsModel != null
              ? homeCubit.getUserSubmissionsModel!.submissions!
                  .map((submission) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            submission.taskDetails != null
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SectionTitleWidget('تفاصيل المهمة',
                                          status: TaskStatusEnum.getStatus(
                                              submission.taskDetails!.tStatus!),
                                          statusIcon: Icons.flag),
                                      ContentWidget(
                                          submission.taskDetails!.tContent!,
                                          Icons.description),
                                      submission.taskDetails!.taskCategory !=
                                              null
                                          ? CategoryRowWidget(
                                              'التصنيف',
                                              submission.taskDetails!
                                                      .taskCategory!.cName ??
                                                  '')
                                          : Container(),

                                      // submission.taskDetails!
                                      //     .assignedToUsers!.isNotEmpty
                                      //     ? AssignedToWidget(
                                      //     'الموظفين المكلفين',
                                      //     submission.taskDetails
                                      //         ?.assignedToUsers!
                                      //         .map((user) => user.name)
                                      //         .join(', ') ??
                                      //         '',
                                      //     Icons.person)
                                      //     : Container(),
                                      MyVerticalSpacer(),
                                      TaskPlanedTimeWidget(
                                          taskModel: submission.taskDetails!),
                                      MyVerticalSpacer(),
                                    ],
                                  )
                                : Container(),
                            SubmissionHeaderWidget(submission),
                            ContentWidget(
                                submission.tsContent ?? '', Icons.content_copy,
                                isSubmission: true),
                            SubmissionMediaWidget(
                              submission: submission,
                              // cubit with mixin
                            ),
                            const MyVerticalSpacer(),
                            // SubmissionTimeWidget(
                            //     submission: submission),

                            const MyVerticalSpacer(),
                            submission.submissionComments!.isNotEmpty
                                ? CommentsSectionWidget(
                                    comments: submission.submissionComments!,
                                    // taskDetailsCubit: taskDetailsCubit,
                                  )
                                : Container(),

                            Row(
                              children: [
                                submission.commentsCount != null &&
                                        submission.commentsCount! > 0
                                    ? Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                NavigationServices.navigateTo(
                                                    context,
                                                    SubmissionCommentsScreen(
                                                        submissionId:
                                                            submission.tsId!));
                                              },
                                              child: Text(
                                                  '${submission.commentsCount} تعليقات')),
                                          // Text('3 تعليقات'),
                                          SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      isDense: true,

                                      // Reduces the overall height and padding
                                      contentPadding:
                                          EdgeInsets.only(bottom: 0),
                                      hintText: "أكتب تعليق ...",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            // color: Colors.blue,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Center(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       showModalBottomSheet(
                            //         // This allows the bottom sheet to resize when the keyboard appears
                            //         isScrollControlled: true,
                            //         context: context,
                            //         builder: (BuildContext context) {
                            //           return BlocProvider.value(
                            //             value: taskDetailsCubit,
                            //             child: Padding(
                            //               padding: EdgeInsets.only(
                            //                 bottom: MediaQuery.of(context)
                            //                     .viewInsets
                            //                     .bottom, // Adjust for keyboard
                            //               ),
                            //               child: Container(
                            //                 padding: EdgeInsets.all(16.0),
                            //                 child: Column(
                            //                   mainAxisSize: MainAxisSize.min,
                            //                   children: [
                            //                     AddCommentWidget(
                            //                       taskId: submission.tsTaskId!,
                            //                       taskSubmissionId: submission.tsId!,
                            //                     ),
                            //                     // SizedBox(height: 20),
                            //                     // ElevatedButton(
                            //                     //   onPressed: () {
                            //                     //     Navigator.pop(context);
                            //                     //   },
                            //                     //   child: Text('Close'),
                            //                     // ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //       ).whenComplete(() {
                            //         // Unfocus when the bottom sheet is dismissed
                            //         taskDetailsCubit.whenCloseBottomSheet();
                            //       });
                            //
                            //       Future.delayed(Duration(milliseconds: 100), () {
                            //         taskDetailsCubit.focusNode.requestFocus();
                            //       });
                            //     },
                            //     child: Text('أكتب تعليق'),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 5,
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  );
                }).toList()
              : [LinearProgressIndicator()],
        ),
      ],
    );
  }
}
