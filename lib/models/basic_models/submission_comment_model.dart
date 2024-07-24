import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class SubmissionCommentModel {
  final int? tscId;
  final int? tscTaskSubmissionId;
  final int? tscCommentedBy;
  final String? tscContent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? commentedByUser;

  SubmissionCommentModel({
    this.tscId,
    this.tscTaskSubmissionId,
    this.tscCommentedBy,
    this.tscContent,
    this.createdAt,
    this.updatedAt,
    this.commentedByUser,
  });

  factory SubmissionCommentModel.fromMap(Map<String, dynamic> json) =>
      SubmissionCommentModel(
        tscId: json["tsc_id"],
        tscTaskSubmissionId: json["tsc_task_submission_id"],
        tscCommentedBy: json["tsc_commented_by"],
        tscContent: json["tsc_content"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        commentedByUser: json["commented_by_user"] == null
            ? null
            : UserModel.fromMap(json["commented_by_user"]),
      );

  Map<String, dynamic> toMap() => {
        "tsc_id": tscId,
        "tsc_task_submission_id": tscTaskSubmissionId,
        "tsc_commented_by": tscCommentedBy,
        "tsc_content": tscContent,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "commented_by_user": commentedByUser?.toMap(),
      };
}
