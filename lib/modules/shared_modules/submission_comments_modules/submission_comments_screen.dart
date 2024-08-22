import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';

class SubmissionCommentsScreen extends StatelessWidget {
  final int submissionId;

  SubmissionCommentsScreen({super.key, required this.submissionId});

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
            return SingleChildScrollView(
              child: Column(
                children: [
                  submissionCommentsCubit.getSubmissionCommentsModel == null
                      ? MyLoader()
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
