import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class GetTasksAssignedToUserModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<TaskModel>? tasks;

  GetTasksAssignedToUserModel({
    this.status,
    this.pagination,
    this.tasks,
  });

  factory GetTasksAssignedToUserModel.fromMap(Map<String, dynamic> json) => GetTasksAssignedToUserModel(
    status: json["status"],
    pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
    tasks: json["tasks"] == null ? [] : List<TaskModel>.from(json["tasks"]!.map((x) => TaskModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "pagination": pagination?.toMap(),
    "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toMap())),
  };
}

