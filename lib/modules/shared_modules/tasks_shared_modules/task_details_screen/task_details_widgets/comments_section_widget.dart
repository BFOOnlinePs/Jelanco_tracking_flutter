import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/models/basic_models/submission_comment_model.dart';

class CommentsSectionWidget extends StatelessWidget {
  final List<SubmissionCommentModel> comments;
  const CommentsSectionWidget(this.comments,{super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('التعليقات:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor)),
        ...comments.map((comment) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[700]),
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
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 4.0),
                  child: Text(
                    comment.tscContent ?? '',
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
