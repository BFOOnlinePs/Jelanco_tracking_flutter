import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class GetUserProfileByIdModel {
  final bool? status;
  final UserModel? userInfo;
  final UserSubmissions? userSubmissions;

  GetUserProfileByIdModel({
    this.status,
    this.userInfo,
    this.userSubmissions,
  });

  factory GetUserProfileByIdModel.fromMap(Map<String, dynamic> json) => GetUserProfileByIdModel(
    status: json["status"],
    userInfo: json["user_info"] == null ? null : UserModel.fromMap(json["user_info"]),
    userSubmissions: json["user_submissions"] == null ? null : UserSubmissions.fromMap(json["user_submissions"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "user_info": userInfo?.toMap(),
    "user_submissions": userSubmissions?.toMap(),
  };
}


class UserSubmissions {
  final PaginationModel? pagination;
  final List<TaskSubmissionModel>? submissions;

  UserSubmissions({
    this.pagination,
    this.submissions,
  });

  factory UserSubmissions.fromMap(Map<String, dynamic> json) => UserSubmissions(
    pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
    submissions: json["submissions"] == null ? [] : List<TaskSubmissionModel>.from(json["submissions"]!.map((x) => TaskSubmissionModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "pagination": pagination?.toMap(),
    "submissions": submissions == null ? [] : List<dynamic>.from(submissions!.map((x) => x.toMap())),
  };
}


