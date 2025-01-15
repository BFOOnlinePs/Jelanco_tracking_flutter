

import 'package:jelanco_tracking_system/models/basic_models/submission_evaluation_model.dart';

class AddSubmissionEvaluationModel {
  final bool? status;
  final String? message;
  final SubmissionEvaluationModel? evaluation;

  AddSubmissionEvaluationModel({
    this.status,
    this.message,
    this.evaluation,
  });

  factory AddSubmissionEvaluationModel.fromMap(Map<String, dynamic> json) => AddSubmissionEvaluationModel(
    status: json["status"],
    message: json["message"],
    evaluation: json["evaluation"] == null ? null : SubmissionEvaluationModel.fromMap(json["evaluation"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "evaluation": evaluation?.toMap(),
  };
}
