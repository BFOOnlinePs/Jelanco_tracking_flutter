import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class AddTaskSubmissionModel {
  final bool? status;
  final String? message;
  final TaskSubmissionModel? taskSubmission;

  AddTaskSubmissionModel({
    this.status,
    this.message,
    this.taskSubmission,
  });

  factory AddTaskSubmissionModel.fromMap(Map<String, dynamic> json) => AddTaskSubmissionModel(
    status: json["status"],
    message: json["message"],
    taskSubmission: json["task_submission"] == null ? null : TaskSubmissionModel.fromMap(json["task_submission"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "task_submission": taskSubmission?.toMap(),
  };
}