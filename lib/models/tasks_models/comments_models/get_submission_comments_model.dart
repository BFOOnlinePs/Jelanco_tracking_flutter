import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';

class GetSubmissionCommentsModel {
  final bool? status;
  final List<TaskSubmissionCommentModel>? submissionComments;

  GetSubmissionCommentsModel({
    this.status,
    this.submissionComments,
  });

  factory GetSubmissionCommentsModel.fromMap(Map<String, dynamic> json) => GetSubmissionCommentsModel(
    status: json["status"],
    submissionComments: json["submission_comments"] == null ? [] : List<TaskSubmissionCommentModel>.from(json["submission_comments"]!.map((x) => TaskSubmissionCommentModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "submission_comments": submissionComments == null ? [] : List<dynamic>.from(submissionComments!.map((x) => x.toMap())),
  };
}
