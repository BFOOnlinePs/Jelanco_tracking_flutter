import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_widget.dart';

class CommentsSectionWidget extends StatelessWidget {
  final List<TaskSubmissionCommentModel> comments;

  // final TaskDetailsCubit? taskDetailsCubit;

  const CommentsSectionWidget({
    super.key,
    required this.comments,
    // this.taskDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('التعليقات:',
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 18,)),
        ...comments.map((comment) {
          return CommentWidget(comment: comment);
        }),
      ],
    );
  }
}
