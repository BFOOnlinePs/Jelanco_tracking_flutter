import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

class SubmissionCommentsScreen extends StatelessWidget {
  final int taskId;
  final int submissionId;

  SubmissionCommentsScreen(
      {super.key, required this.taskId, required this.submissionId});

  late SubmissionCommentsCubit submissionCommentsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'التعليقات',
      ),
      body: BlocProvider(
        create: (context) => SubmissionCommentsCubit()
          ..getSubmissionComments(submissionId: submissionId),
        child: BlocConsumer<SubmissionCommentsCubit, SubmissionCommentsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            submissionCommentsCubit = SubmissionCommentsCubit.get(context);
            return MyRefreshIndicator(
              onRefresh: () async {
                await submissionCommentsCubit.getSubmissionComments(
                    submissionId: submissionId);
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      submissionCommentsCubit.getSubmissionCommentsModel == null
                          ? const Center(child: MyLoader())
                          : submissionCommentsCubit.getSubmissionCommentsModel
                                      ?.submissionComments !=
                                  null
                              ? Column(
                                  children: submissionCommentsCubit
                                      .getSubmissionCommentsModel!
                                      .submissionComments!
                                      .map((comment) {
                                    return CommentWidget(comment: comment);
                                  }).toList(),
                                )
                              : Container(),
                      ElevatedButton(
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
                                        taskId: taskId,
                                        taskSubmissionId: submissionId,
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
                          ).whenComplete(() {
                            // .............................................................
                            // // Unfocus when the bottom sheet is dismissed
                            // taskDetailsCubit.whenCloseBottomSheet();
                          });
                
                          // ......................
                          // Future.delayed(Duration(milliseconds: 100), () {
                          //   taskDetailsCubit.focusNode.requestFocus();
                          // });
                        },
                        child: Text('أكتب تعليق'),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
