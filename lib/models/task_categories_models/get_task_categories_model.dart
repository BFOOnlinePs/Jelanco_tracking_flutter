import '../basic_models/task_category_model.dart';

class GetTaskCategoriesModel {
  final bool? status;
  final List<TaskCategoryModel>? taskCategories;

  GetTaskCategoriesModel({
    this.status,
    this.taskCategories,
  });

  factory GetTaskCategoriesModel.fromMap(Map<String, dynamic> json) => GetTaskCategoriesModel(
    status: json["status"],
    taskCategories: json["task_categories"] == null ? [] : List<TaskCategoryModel>.from(json["task_categories"]!.map((x) => TaskCategoryModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "task_categories": taskCategories == null ? [] : List<dynamic>.from(taskCategories!.map((x) => x.toMap())),
  };
}

