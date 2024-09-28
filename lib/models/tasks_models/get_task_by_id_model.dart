import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class GetTaskByIdModel {
  final bool? status;
  final TaskModel? task;

  GetTaskByIdModel({
    this.status,
    this.task,
  });

  factory GetTaskByIdModel.fromMap(Map<String, dynamic> json) => GetTaskByIdModel(
    status: json["status"],
    task: json["task"] == null ? null : TaskModel.fromMap(json["task"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "task": task?.toMap(),
  };
}
