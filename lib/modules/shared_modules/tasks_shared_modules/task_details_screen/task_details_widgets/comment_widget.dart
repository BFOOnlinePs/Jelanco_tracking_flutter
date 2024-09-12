import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comment_media_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';

class CommentWidget extends StatelessWidget {
  final TaskSubmissionCommentModel comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 18,
                      backgroundImage: comment.commentedByUser?.image !=
                          null
                          ? NetworkImage(EndPointsConstants
                          .profileStorage +
                          comment.commentedByUser!.image!)
                          : const AssetImage(AssetsKeys
                          .defaultProfileImage)
                      as ImageProvider,

                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.commentedByUser?.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 10,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            MyDateUtils.formatDateTimeWithAmPm(
                                comment.createdAt),
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              comment.isCurrentVersion == false
                  ? Icon(Icons.history_toggle_off)
                  : Container(),
            ],
          ),
          Container(
            margin: EdgeInsetsDirectional.only(start: 48),
            width: double.infinity,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.tscContent ?? '',
                      style: TextStyle(color: Colors.grey[800], fontSize: 14),
                    ),
                  ],
                ),
                CommentMediaWidget(
                  comment: comment,
                  // taskDetailsCubit: taskDetailsCubit,
                ),
              ],
            ),
          ),

          // Divider(thickness: 0.5, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
