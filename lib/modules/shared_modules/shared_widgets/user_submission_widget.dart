import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/submission_comments_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_task_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class UserSubmissionWidget extends StatelessWidget {
  HomeCubit? homeCubit;
  UserProfileCubit? userProfileCubit;
  TaskSubmissionModel submission;

  UserSubmissionWidget({super.key, this.userProfileCubit, this.homeCubit, required this.submission});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsetsDirectional.only(
              start: 16, end: 16, top: 6, bottom: 0),
          child: InkWell(
            onTap: () {
              NavigationServices.navigateTo(context,
                  TaskSubmissionDetailsScreen(submissionId: submission.tsId!));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubmissionHeaderWidget(
                    submissionModel: submission, homeCubit: homeCubit, userProfileCubit: userProfileCubit,),


                ContentWidget(submission.tsContent ?? '', isSubmission: true),
                SubmissionMediaWidget(
                  submission: submission,
                ),
                submission.taskDetails != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyVerticalSpacer(),

                          // SectionTitleWidget('تفاصيل المهمة',
                          //     status: TaskStatusEnum.getStatus(
                          //         submission.taskDetails!.tStatus!),
                          //     statusIcon: Icons.flag),
                          //                         Text('تم إسناد هذا التسليم إلى المهمة ادناه:'),
                          SubmissionTaskWidget(
                              taskContent: submission.taskDetails!.tContent!,
                              taskId: submission.tsTaskId!),
                          // ContentWidget(
                          //   submission.taskDetails!.tContent!,
                          // ),
                          // submission.taskDetails!.taskCategory !=
                          //         null
                          // ? CategoryRowWidget(
                          //     'التصنيف',
                          //     submission.taskDetails!
                          //             .taskCategory!.cName ??
                          //         '')
                          // : Container(),

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
                          // MyVerticalSpacer(),
                          // TaskPlanedTimeWidget(
                          //     taskModel: submission.taskDetails!),
                          // MyVerticalSpacer(),
                        ],
                      )
                    : Container(),
                // SubmissionTimeWidget(
                //     submission: submission),

                // const MyVerticalSpacer(),
                // submission.submissionComments!.isNotEmpty
                //     ? CommentsSectionWidget(
                //         comments: submission.submissionComments!,
                //         // taskDetailsCubit: taskDetailsCubit,
                //       )
                //     : Container(),
                const SizedBox(height: 8,),
                if (SystemPermissions.hasPermission(
                    SystemPermissions.viewComments))
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
                                          taskId: submission.tsTaskId ?? -1,
                                          submissionId: submission.tsId!,
                                          onPopCallback: () {
                                            return homeCubit != null
                                                ? homeCubit!.getCommentsCount(
                                                    submissionId:
                                                        submission.tsId!)
                                                : userProfileCubit != null
                                                    ? userProfileCubit!
                                                        .getCommentsCount(
                                                            submissionId:
                                                                submission
                                                                    .tsId!)
                                                    : print(
                                                        'no get comments count function provided');
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                        '${submission.commentsCount} تعليقات')),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            )
                          : Container(),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            NavigationServices.navigateTo(
                              context,
                              SubmissionCommentsScreen(
                                taskId: submission.tsTaskId!,
                                submissionId: submission.tsId!,
                                onPopCallback: () {
                                  return homeCubit != null
                                      ? homeCubit!.getCommentsCount(
                                          submissionId: submission.tsId!)
                                      : userProfileCubit != null
                                          ? userProfileCubit!.getCommentsCount(
                                              submissionId: submission.tsId!)
                                          : print(
                                              'no get comments count function provided');
                                },
                              ),
                            );
                          },
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.only(bottom: 0),

                              /// may changed later
                              hintText: SystemPermissions.hasPermission(
                                      SystemPermissions.addComment)
                                  ? "أضف تعليق ..."
                                  : 'مشاهدة التعليقات',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 5,
        ),
      ],
    );
  }
}
