import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class GetTaskSubmissionWithTaskAndCommentsModel {
  final bool? status;
  final TaskSubmissionModel? taskSubmission;

  GetTaskSubmissionWithTaskAndCommentsModel({
    this.status,
    this.taskSubmission,
  });

  factory GetTaskSubmissionWithTaskAndCommentsModel.fromMap(Map<String, dynamic> json) =>
      GetTaskSubmissionWithTaskAndCommentsModel(
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
