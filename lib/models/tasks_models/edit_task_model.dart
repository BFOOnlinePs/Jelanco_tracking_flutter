import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class EditTaskModel {
  final bool? status;
  final String? message;
  final TaskModel? task;

  EditTaskModel({
    this.status,
    this.message,
    this.task,
  });

  factory EditTaskModel.fromMap(Map<String, dynamic> json) => EditTaskModel(
        status: json["status"],
        message: json["message"],
        task: json["task"] == null ? null : TaskModel.fromMap(json["task"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "task": task?.toMap(),
      };
}
