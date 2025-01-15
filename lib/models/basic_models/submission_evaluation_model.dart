import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class SubmissionEvaluationModel {
  final int? seId;
  final int? seTaskId;
  final int? seSubmissionId;
  final int? seEvaluatorId;
  final double? seRating;
  final String? seEvaluatorNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? evaluatorUser;

  SubmissionEvaluationModel({
    this.seId,
    this.seTaskId,
    this.seSubmissionId,
    this.seEvaluatorId,
    this.seRating,
    this.seEvaluatorNotes,
    this.createdAt,
    this.updatedAt,
    this.evaluatorUser,
  });

  factory SubmissionEvaluationModel.fromMap(Map<String, dynamic> json) => SubmissionEvaluationModel(
    seId: json["se_id"],
    seTaskId: json["se_task_id"],
    seSubmissionId: json["se_submission_id"],
    seEvaluatorId: json["se_evaluator_id"],
    seRating: json["se_rating"]?.toDouble(),
    seEvaluatorNotes: json["se_evaluator_notes"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    evaluatorUser: json["evaluator_user"] == null ? null : UserModel.fromMap(json["evaluator_user"]),
  );

  Map<String, dynamic> toMap() => {
    "se_id": seId,
    "se_task_id": seTaskId,
    "se_submission_id": seSubmissionId,
    "se_evaluator_id": seEvaluatorId,
    "se_rating": seRating,
    "se_evaluator_notes": seEvaluatorNotes,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "evaluator_user": evaluatorUser?.toMap(),
  };
}