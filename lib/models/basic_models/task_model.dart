class TaskModel {
  final int? tId;
  final String? tContent;
  final DateTime? tPlanedStartTime;
  final DateTime? tPlanedEndTime;
  final String? tStatus;
  final String? tCategoryId;
  final int? tAddedBy;
  final String? tAssignedTo;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  TaskModel({
    this.tContent,
    this.tPlanedStartTime,
    this.tPlanedEndTime,
    this.tStatus,
    this.tCategoryId,
    this.tAddedBy,
    this.tAssignedTo,
    this.updatedAt,
    this.createdAt,
    this.tId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    tContent: json["t_content"],
    tPlanedStartTime: json["t_planed_start_time"] == null ? null : DateTime.parse(json["t_planed_start_time"]),
    tPlanedEndTime: json["t_planed_end_time"] == null ? null : DateTime.parse(json["t_planed_end_time"]),
    tStatus: json["t_status"],
    tCategoryId: json["t_category_id"],
    tAddedBy: json["t_added_by"],
    tAssignedTo: json["t_assigned_to"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    tId: json["t_id"],
  );

  Map<String, dynamic> toMap() => {
    "t_content": tContent,
    "t_planed_start_time": tPlanedStartTime?.toIso8601String(),
    "t_planed_end_time": tPlanedEndTime?.toIso8601String(),
    "t_status": tStatus,
    "t_category_id": tCategoryId,
    "t_added_by": tAddedBy,
    "t_assigned_to": tAssignedTo,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "t_id": tId,
  };
}
