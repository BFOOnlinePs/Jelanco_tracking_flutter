import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_media_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';

class CommentsSectionWidget extends StatelessWidget {
  final List<TaskSubmissionCommentModel> comments;
  final TaskDetailsCubit taskDetailsCubit;

  const CommentsSectionWidget({
    super.key,
    required this.comments,
    required this.taskDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('التعليقات:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor)),
        ...comments.map((comment) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 10),
                    Text(
                      comment.commentedByUser?.name ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.tscContent ?? '',
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      CommentMediaWidget(
                          comment: comment, taskDetailsCubit: taskDetailsCubit),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            MyDateUtils.formatDateTime2(comment.createdAt),
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          // MyTextButtonNoBorder(
                          //   onPressed: () {
                          //
                          //   },
                          //   child: const Text(
                          //     'رد',
                          //     style: TextStyle(
                          //       color: ColorsConstants.primaryColor,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
