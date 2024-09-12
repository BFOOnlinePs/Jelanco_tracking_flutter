import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';

class ShowModalAddCommentButton extends StatelessWidget {
  final int taskId;
  final int submissionId;

  const ShowModalAddCommentButton(
      {super.key, required this.taskId, required this.submissionId});

  @override
  Widget build(BuildContext context) {
    return MyTextButton(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AddCommentWidget(
                        taskId: taskId,
                        taskSubmissionId: submissionId,
                        whenCommentAdded: () {
                          // call
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),

                  hintText: "أضف تعليقاً ...",
                  // no border
                  border: InputBorder.none,
                ),
              ),
            ),
            Transform.rotate(
              angle: 3.14 * 1.25,
              child: const Icon(FontAwesomeIcons.locationArrow),
            )
          ],
        ));
  }
}
