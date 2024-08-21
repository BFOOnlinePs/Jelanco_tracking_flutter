class GetTasksModel {
  final bool? status;
  final Pagination? pagination;
  final List<Task>? tasks;

  GetTasksModel({
    this.status,
    this.pagination,
    this.tasks,
  });

  factory GetTasksModel.fromMap(Map<String, dynamic> json) => GetTasksModel(
        status: json["status"],
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromMap(json["pagination"]),
        tasks: json["tasks"] == null
            ? []
            : List<Task>.from(json["tasks"]!.map((x) => Task.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "pagination": pagination?.toMap(),
        "tasks": tasks == null
            ? []
            : List<dynamic>.from(tasks!.map((x) => x.toMap())),
      };
}

class Pagination {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? totalItems;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.totalItems,
  });

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        totalItems: json["total_items"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "total_items": totalItems,
      };
}

class Task {
  final int? tId;
  final String? tContent;
  final DateTime? tPlanedStartTime;
  final DateTime? tPlanedEndTime;
  final String? tStatus;
  final int? tCategoryId;
  final int? tAddedBy;
  final String? tAssignedTo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TaskCategory? taskCategory;
  final AddedByUser? addedByUser;

  Task({
    this.tId,
    this.tContent,
    this.tPlanedStartTime,
    this.tPlanedEndTime,
    this.tStatus,
    this.tCategoryId,
    this.tAddedBy,
    this.tAssignedTo,
    this.createdAt,
    this.updatedAt,
    this.taskCategory,
    this.addedByUser,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        tId: json["t_id"],
        tContent: json["t_content"],
        tPlanedStartTime: json["t_planed_start_time"] == null
            ? null
            : DateTime.parse(json["t_planed_start_time"]),
        tPlanedEndTime: json["t_planed_end_time"] == null
            ? null
            : DateTime.parse(json["t_planed_end_time"]),
        tStatus: json["t_status"],
        tCategoryId: json["t_category_id"],
        tAddedBy: json["t_added_by"],
        tAssignedTo: json["t_assigned_to"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        taskCategory: json["task_category"] == null
            ? null
            : TaskCategory.fromMap(json["task_category"]),
        addedByUser: json["added_by_user"] == null
            ? null
            : AddedByUser.fromMap(json["added_by_user"]),
      );

  Map<String, dynamic> toMap() => {
        "t_id": tId,
        "t_content": tContent,
        "t_planed_start_time": tPlanedStartTime?.toIso8601String(),
        "t_planed_end_time": tPlanedEndTime?.toIso8601String(),
        "t_status": tStatus,
        "t_category_id": tCategoryId,
        "t_added_by": tAddedBy,
        "t_assigned_to": tAssignedTo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "task_category": taskCategory?.toMap(),
        "added_by_user": addedByUser?.toMap(),
      };
}

class AddedByUser {
  final int? id;
  final String? name;

  AddedByUser({
    this.id,
    this.name,
  });

  factory AddedByUser.fromMap(Map<String, dynamic> json) => AddedByUser(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}

class TaskCategory {
  final int? cId;
  final String? cName;

  TaskCategory({
    this.cId,
    this.cName,
  });

  factory TaskCategory.fromMap(Map<String, dynamic> json) => TaskCategory(
        cId: json["c_id"],
        cName: json["c_name"],
      );

  Map<String, dynamic> toMap() => {
        "c_id": cId,
        "c_name": cName,
      };
}
