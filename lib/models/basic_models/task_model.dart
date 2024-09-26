import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';

class TaskModel {
  final int? tId;
  final String? tContent;
  final DateTime? tPlanedStartTime;
  final DateTime? tPlanedEndTime;
  final String? tStatus;
  final int? tCategoryId;
  final int? tAddedBy;
  final String? tAssignedTo;
  final String? tSupervisorNotes;
  final String? tManagerNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserModel>? assignedToUsers;
  final TaskCategoryModel? taskCategory;
  final UserModel? addedByUser;
  final AttachmentsCategories? taskAttachmentsCategories;

  List<TaskSubmissionModel>? taskSubmissions;

  TaskModel({
    this.tId,
    this.tContent,
    this.tPlanedStartTime,
    this.tPlanedEndTime,
    this.tStatus,
    this.tCategoryId,
    this.tAddedBy,
    this.tAssignedTo,
    this.tSupervisorNotes,
    this.tManagerNotes,
    this.createdAt,
    this.updatedAt,
    this.assignedToUsers,
    this.taskCategory,
    this.addedByUser,
    this.taskAttachmentsCategories,
    this.taskSubmissions,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
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
        tSupervisorNotes: json["t_supervisor_notes"],
        tManagerNotes: json["t_manager_notes"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        assignedToUsers: json["assigned_to_users"] == null
            ? []
            : List<UserModel>.from(
                json["assigned_to_users"]!.map((x) => UserModel.fromMap(x))),
        taskCategory: json["task_category"] == null
            ? null
            : TaskCategoryModel.fromMap(json["task_category"]),
        addedByUser: json["added_by_user"] == null
            ? null
            : UserModel.fromMap(json["added_by_user"]),
        taskAttachmentsCategories: json["task_attachments_categories"] == null
            ? null
            : AttachmentsCategories.fromMap(
                json["task_attachments_categories"]),
        taskSubmissions: json["task_submissions"] == null
            ? []
            : List<TaskSubmissionModel>.from(json["task_submissions"]!
                .map((x) => TaskSubmissionModel.fromMap(x))),
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
        "t_supervisor_notes": tSupervisorNotes,
        "t_manager_notes": tManagerNotes,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "assigned_to_users": assignedToUsers == null
            ? []
            : List<dynamic>.from(assignedToUsers!.map((x) => x.toMap())),
        "task_category": taskCategory?.toMap(),
        "added_by_user": addedByUser?.toMap(),
        "task_attachments_categories": taskAttachmentsCategories?.toMap(),
        "task_submissions": taskSubmissions == null
            ? []
            : List<dynamic>.from(taskSubmissions!.map((x) => x.toMap())),
      };
}
