import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';

class AddTaskSubmissionCommentModel {
  final bool? status;
  final String? message;
  final TaskSubmissionCommentModel? comment;

  AddTaskSubmissionCommentModel({
    this.status,
    this.message,
    this.comment,
  });

  factory AddTaskSubmissionCommentModel.fromMap(Map<String, dynamic> json) => AddTaskSubmissionCommentModel(
    status: json["status"],
    message: json["message"],
    comment: json["comment"] == null ? null : TaskSubmissionCommentModel.fromMap(json["comment"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "comment": comment?.toMap(),
  };
}