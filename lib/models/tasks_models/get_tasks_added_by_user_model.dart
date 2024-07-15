import '../basic_models/pagination_model.dart';
import '../basic_models/task_model.dart';

class GetTasksAddedByUserModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<TaskModel>? tasks;

  GetTasksAddedByUserModel({
    this.status,
    this.pagination,
    this.tasks,
  });

  factory GetTasksAddedByUserModel.fromMap(Map<String, dynamic> json) => GetTasksAddedByUserModel(
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
