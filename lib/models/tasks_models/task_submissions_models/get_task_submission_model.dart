import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class GetTaskSubmissionModel {
  final bool? status;
  final TaskSubmissionModel? taskSubmission;

  GetTaskSubmissionModel({
    this.status,
    this.taskSubmission,
  });

  factory GetTaskSubmissionModel.fromMap(Map<String, dynamic> json) =>
      GetTaskSubmissionModel(
        status: json["status"],
        taskSubmission: json["task_submission"] == null
            ? null
            : TaskSubmissionModel.fromMap(json["task_submission"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "task_submission": taskSubmission?.toMap(),
      };
}
