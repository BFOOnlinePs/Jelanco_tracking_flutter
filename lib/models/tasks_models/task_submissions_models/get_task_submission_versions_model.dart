import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class GetTaskSubmissionVersionsModel {
  final bool? status;
  final List<TaskSubmissionModel>? submissionsVersions;

  GetTaskSubmissionVersionsModel({
    this.status,
    this.submissionsVersions,
  });

  factory GetTaskSubmissionVersionsModel.fromMap(Map<String, dynamic> json) =>
      GetTaskSubmissionVersionsModel(
        status: json["status"],
        submissionsVersions: json["submissions_versions"] == null
            ? []
            : List<TaskSubmissionModel>.from(json["submissions_versions"]!
                .map((x) => TaskSubmissionModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "submissions_versions": submissionsVersions == null
            ? []
            : List<dynamic>.from(submissionsVersions!.map((x) => x.toMap())),
      };
}
