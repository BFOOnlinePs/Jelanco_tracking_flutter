import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/submission_comments_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_task_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_cubit.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class UserSubmissionWidget extends StatelessWidget {
  // the cubits are used for:
  // show the edited submission immediately (when back from edit submission screen)
  // show the updated number of comments (when back from comment screen)
  HomeCubit? homeCubit;
  UserProfileCubit? userProfileCubit;
  TodaySubmissionsCubit? todaySubmissionsCubit;
  TaskSubmissionModel submission;

  UserSubmissionWidget({
    super.key,
    this.userProfileCubit,
    this.homeCubit,
    this.todaySubmissionsCubit,
    required this.submission,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 6.h, bottom: 0.h),
          child: InkWell(
            onTap: () {
              NavigationServices.navigateTo(context, TaskSubmissionDetailsScreen(submissionId: submission.tsId!));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubmissionHeaderWidget(
                  isTaskCancelled: submission.taskDetails?.tStatus == TaskStatusEnum.canceled.statusName,
                  submissionModel: submission,
                  // homeCubit: homeCubit,
                  // userProfileCubit: userProfileCubit,
                  // todaySubmissionsCubit: todaySubmissionsCubit,
                ),
                ContentWidget(
                  submission.tsContent ?? '',
                  isSubmission: true,
                  isTextExpanded: false,
                ),
                MediaWidget(
                  attachmentsCategories: submission.submissionAttachmentsCategories!,
                  storagePath: EndPointsConstants.taskSubmissionsStorage,
                  isOpenInMediaViewer: false,
                ),
                submission.taskDetails != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const MyVerticalSpacer(),
                          SubmissionTaskWidget(taskContent: submission.taskDetails!.tContent!, taskId: submission.tsTaskId!),
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
                const SizedBox(
                  height: 8,
                ),
                if (SystemPermissions.hasPermission(SystemPermissions.viewComments))
                  Row(
                    children: [
                      submission.commentsCount != null && submission.commentsCount! > 0
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
                                            if (SystemPermissions.hasPermission(SystemPermissions.viewComments)) {
                                              if (homeCubit != null) {
                                                return homeCubit!.getCommentsCount(submissionId: submission.tsId!);
                                              } else if (userProfileCubit != null) {
                                                return userProfileCubit!.getCommentsCount(submissionId: submission.tsId!);
                                              } else if (todaySubmissionsCubit != null) {
                                                return todaySubmissionsCubit!.getCommentsCount(submissionId: submission.tsId!);
                                              } else {
                                                print('no get comments count function provided');
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    child: submission.commentsCount == 1
                                        ? Text('${submission.commentsCount} تعليق')
                                        : Text('${submission.commentsCount} تعليقات')),
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
                                  if (SystemPermissions.hasPermission(SystemPermissions.viewComments)) {
                                    if (homeCubit != null) {
                                      return homeCubit!.getCommentsCount(submissionId: submission.tsId!);
                                    } else if (userProfileCubit != null) {
                                      return userProfileCubit!.getCommentsCount(submissionId: submission.tsId!);
                                    } else if (todaySubmissionsCubit != null) {
                                      return todaySubmissionsCubit!.getCommentsCount(submissionId: submission.tsId!);
                                    } else {
                                      print('no get comments count function provided');
                                    }
                                  }
                                },
                              ),
                            );
                          },
                          child:
                              // !SystemPermissions.hasPermission(
                              //     SystemPermissions.addComment) && submission.commentsCount  ?
                              TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.only(bottom: 0),

                              /// may change later
                              hintText:
                                  SystemPermissions.hasPermission(SystemPermissions.addComment) ? "أضف تعليق ..." : 'مشاهدة التعليقات',
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
