import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';

class AddTaskModel {
  final bool? status;
  final String? message;
  final TaskModel? task;
  // if uncomment (in api return the category id as int instead of string)

  AddTaskModel({
    this.status,
    this.message,
    this.task,
  });

  factory AddTaskModel.fromMap(Map<String, dynamic> json) => AddTaskModel(
    status: json["status"],
    message: json["message"],
    task: TaskModel.fromMap(json["task"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "task": task?.toMap(),
  };
}