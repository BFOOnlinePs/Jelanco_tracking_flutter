import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/socket_io.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

class SubmissionCommentsScreen extends StatelessWidget {
  final int taskId;
  final int submissionId;
  final VoidCallback onPopCallback;

  SubmissionCommentsScreen({
    super.key,
    required this.taskId,
    required this.submissionId,
    required this.onPopCallback,
  });

  late SubmissionCommentsCubit submissionCommentsCubit;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'التعليقات',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Call the callback function before popping
            onPopCallback();
            // TODO: update the number only when changed
            print("pop");
            Navigator.pop(context);

          },
        ),
      ),
      body: BlocProvider(
        create: (context) => SubmissionCommentsCubit()
          ..getSubmissionComments(submissionId: submissionId)
          ..listenToNewComments(),
        child: BlocConsumer<SubmissionCommentsCubit, SubmissionCommentsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            // print('state is: in builder $state');
            submissionCommentsCubit = SubmissionCommentsCubit.get(context);
            if (submissionCommentsCubit.count == 0) {
              // Defer the UI update until after the build phase
              WidgetsBinding.instance.addPostFrameCallback((_) {
                submissionCommentsCubit.toEmit();
                print(
                    'submissionCommentsCubit.count: ${submissionCommentsCubit.count}');
                openBottomSheet(context);
              });
            }

            return Stack(
              children: [
                MyRefreshIndicator(
                  onRefresh: () async {
                    await submissionCommentsCubit.getSubmissionComments(
                        submissionId: submissionId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      controller: submissionCommentsCubit.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          submissionCommentsCubit.getSubmissionCommentsModel ==
                                  null
                              ? const Center(child: MyLoader())
                              : submissionCommentsCubit
                                          .getSubmissionCommentsModel
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
                              openBottomSheet(context);
                            },
                            child: Text('أكتب تعليق'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                state is GetSubmissionCommentsLoadingState &&
                        submissionCommentsCubit.getSubmissionCommentsModel !=
                            null
                    ? LoaderWithDisable()
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      // This allows the bottom sheet to resize when the keyboard appears
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AddCommentWidget(
                  // commentService: commentService,
                  taskId: taskId,
                  taskSubmissionId: submissionId,
                  whenCommentAdded: () async {
                    // await submissionCommentsCubit.getSubmissionComments(
                    //     submissionId: submissionId);

                    // wait 0.2 seconds before scrolling
                    await Future.delayed(
                      const Duration(milliseconds: 200),
                    );
                    ScrollUtils.scrollPosition(
                        scrollController:
                            submissionCommentsCubit.scrollController,
                        offset: submissionCommentsCubit
                            .scrollController.position.maxScrollExtent);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
