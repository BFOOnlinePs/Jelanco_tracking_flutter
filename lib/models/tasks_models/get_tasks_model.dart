import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class GetTasksModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<TaskModel>? tasks;

  GetTasksModel({
    this.status,
    this.pagination,
    this.tasks,
  });

  factory GetTasksModel.fromMap(Map<String, dynamic> json) => GetTasksModel(
        status: json["status"],
        pagination: json["pagination"] == null
            ? null
            : PaginationModel.fromMap(json["pagination"]),
        tasks: json["tasks"] == null
            ? []
            : List<TaskModel>.from(json["tasks"]!.map((x) => TaskModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "pagination": pagination?.toMap(),
        "tasks": tasks == null
            ? []
            : List<dynamic>.from(tasks!.map((x) => x.toMap())),
      };
}
