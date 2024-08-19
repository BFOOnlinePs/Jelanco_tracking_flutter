import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

class GetUserSubmissionsModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<TaskSubmissionModel>? submissions;

  GetUserSubmissionsModel({
    this.status,
    this.pagination,
    this.submissions,
  });

  factory GetUserSubmissionsModel.fromMap(Map<String, dynamic> json) => GetUserSubmissionsModel(
    status: json["status"],
    pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
    submissions: json["submissions"] == null ? [] : List<TaskSubmissionModel>.from(json["submissions"]!.map((x) => TaskSubmissionModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "pagination": pagination?.toMap(),
    "submissions": submissions == null ? [] : List<dynamic>.from(submissions!.map((x) => x.toMap())),
  };
}