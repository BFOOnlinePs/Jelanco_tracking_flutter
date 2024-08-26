import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
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
                    backgroundImage: AssetImage(
                      AssetsKeys.defaultProfileImage ?? '',
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              comment.commentedByUser?.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.white,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.tscContent ?? '',
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 14),
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
                                  MyDateUtils.formatDateTimeWithAmPm(
                                      comment.createdAt),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
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
                ],
              ),
              comment.isCurrentVersion == false
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // SizedBox(
                        //   width: 66,
                        // ),
                        // Spacer(),
                        Icon(Icons.history_toggle_off),
                      ],
                    )
                  : Container(),
            ],
          ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
