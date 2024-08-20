import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import '../../widgets/my_drawer/my_drawer.dart';
import '../../widgets/my_spacers/my_vertical_spacer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'home_page_title'.tr(),
      ),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile and Input Field
          InkWell(
            onTap: () {
              // task id = -1, since the submission has no task
              NavigationServices.navigateTo(
                  context, AddTaskSubmissionScreen(taskId: -1));
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.only(
                          start: 16, end: 16, top: 16, bottom: 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        // backgroundImage: AssetImage(
                        //     'assets/profile.jpg'),e
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ماذا فعلت اليوم؟",
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 0.2,
                ),

                // Media Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MediaOptionWidget(
                      icon: Icons.image,
                      label: 'صور',
                      color: Colors.green,
                      onTap: () {
                        NavigationServices.navigateTo(
                            context, AddTaskSubmissionScreen(taskId: -1));
                      },
                    ),
                    Container(width: 0.2, height: 26, color: Colors.grey),
                    MediaOptionWidget(
                      icon: Icons.video_camera_back,
                      label: 'فيديوهات',
                      color: Colors.red,
                      onTap: () {
                        NavigationServices.navigateTo(
                            context, AddTaskSubmissionScreen(taskId: -1));
                      },
                    ),
                    Container(width: 0.2, height: 26, color: Colors.grey),
                    MediaOptionWidget(
                      icon: Icons.attach_file,
                      label: 'ملفات',
                      color: Colors.blue,
                      onTap: () {
                        NavigationServices.navigateTo(
                            context, AddTaskSubmissionScreen(taskId: -1));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(
            thickness: 5,
          ),

          BlocProvider(
            create: (context) => HomeCubit()..getUserSubmissions(),
            child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {},
              builder: (context, state) {
                homeCubit = HomeCubit.get(context);
                return Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(16.0),
                          // decoration: BoxDecoration(
                          //   color: Colors.grey.withOpacity(0.04),
                          //   border: const Border(
                          //     right: BorderSide(
                          //       color: ColorsConstants.secondaryColor,
                          //       width: 5.0,
                          //     ),
                          //   ),
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: homeCubit.getUserSubmissionsModel != null
                                ? homeCubit
                                    .getUserSubmissionsModel!.submissions!
                                    .map((submission) {
                                    return Column(
                                      children: [
                                        SubmissionHeaderWidget(submission),
                                        ContentWidget(
                                            'Content',
                                            submission.tsContent ?? '',
                                            Icons.content_copy,
                                            isSubmission: true),
                                        SubmissionMediaWidget(
                                          submission: submission,
                                          // cubit with mixin
                                        ),
                                        MyVerticalSpacer(),
                                        SubmissionTimeWidget(
                                            submission: submission),
                                        MyVerticalSpacer(),
                                        submission
                                                .submissionComments!.isNotEmpty
                                            ? CommentsSectionWidget(
                                                comments: submission
                                                    .submissionComments!,
                                                // taskDetailsCubit: taskDetailsCubit,
                                              )
                                            : Container(),
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
                                    );
                                  }).toList()
                                : [Container()],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}