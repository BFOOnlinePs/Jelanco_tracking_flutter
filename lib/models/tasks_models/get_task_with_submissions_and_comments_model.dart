import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class GetTaskWithSubmissionsAndCommentsModel {
  final bool? status;
  final TaskModel? task;

  GetTaskWithSubmissionsAndCommentsModel({
    this.status,
    this.task,
  });

  factory GetTaskWithSubmissionsAndCommentsModel.fromMap(
          Map<String, dynamic> json) =>
      GetTaskWithSubmissionsAndCommentsModel(
        status: json["status"],
        task: json["task"] == null ? null : TaskModel.fromMap(json["task"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "task": task?.toMap(),
      };
}
