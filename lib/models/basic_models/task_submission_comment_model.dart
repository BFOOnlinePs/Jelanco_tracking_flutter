import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class TaskSubmissionCommentModel {
  final int? tscTaskId;
  final int? tscTaskSubmissionId;
  final int? tscParentId;
  final int? tscCommentedBy;
  final String? tscContent;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? tscId;
  final UserModel? commentedByUser;

  TaskSubmissionCommentModel({
    this.tscTaskId,
    this.tscTaskSubmissionId,
    this.tscParentId,
    this.tscCommentedBy,
    this.tscContent,
    this.updatedAt,
    this.createdAt,
    this.tscId,
    this.commentedByUser,
  });

  factory TaskSubmissionCommentModel.fromMap(Map<String, dynamic> json) =>
      TaskSubmissionCommentModel(
        tscTaskId: json["tsc_task_id"],
        tscTaskSubmissionId: json["tsc_task_submission_id"],
        tscParentId: json["tsc_parent_id"],
        tscCommentedBy: json["tsc_commented_by"],
        tscContent: json["tsc_content"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tscId: json["tsc_id"],
        commentedByUser: json["commented_by_user"] == null
            ? null
            : UserModel.fromMap(json["commented_by_user"]),
      );

  Map<String, dynamic> toMap() => {
        "tsc_task_id": tscTaskId,
        "tsc_task_submission_id": tscTaskSubmissionId,
        "tsc_parent_id": tscParentId,
        "tsc_commented_by": tscCommentedBy,
        "tsc_content": tscContent,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "tsc_id": tscId,
        "commented_by_user": commentedByUser?.toMap(),
      };
}
