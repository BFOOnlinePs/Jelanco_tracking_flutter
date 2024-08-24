import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_media_widget.dart';

class CommentWidget extends StatelessWidget {
  final TaskSubmissionCommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  comment.commentedByUser?.name ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 14),
                ),
              ),
              comment.isCurrentVersion == false ?
              Row(
                children: [
                  SizedBox(
                    width: 2,
                  ),
                  Icon(Icons.history_toggle_off),
                ],
              ) : Container()
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
                  comment: comment,
                  // taskDetailsCubit: taskDetailsCubit,
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      MyDateUtils.formatDateTimeWithAmPm(comment.createdAt),
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
  }
}
