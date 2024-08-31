import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';

class TaskSubmissionModel {
  final int? tsId;
  final int? tsTaskId;
  final int? tsSubmitter;
  final String? tsContent;
  final DateTime? tsActualStartTime;
  final DateTime? tsActualEndTime;
  final String? tsStartLatitude;
  final String? tsStartLongitude;
  final String? tsEndLatitude;
  final String? tsEndLongitude;
  final String? tsStatus;
  final int? tsParentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? submitterUser;
  final List<TaskSubmissionCommentModel>? submissionComments;
  final AttachmentsCategories? submissionAttachmentsCategories;
  int? commentsCount;
  final TaskModel? taskDetails;

  TaskSubmissionModel({
    this.tsId,
    this.tsTaskId,
    this.tsSubmitter,
    this.tsContent,
    this.tsActualStartTime,
    this.tsActualEndTime,
    this.tsStartLatitude,
    this.tsStartLongitude,
    this.tsEndLatitude,
    this.tsEndLongitude,
    this.tsStatus,
    this.tsParentId,
    this.createdAt,
    this.updatedAt,
    this.submitterUser,
    this.submissionComments,
    this.submissionAttachmentsCategories,
    this.commentsCount,
    this.taskDetails,
  });

  TaskSubmissionModel copyWith({
    int? tsId,
    int? tsTaskId,
    int? tsSubmitter,
    String? tsContent,
    DateTime? tsActualStartTime,
    DateTime? tsActualEndTime,
    String? tsStartLatitude,
    String? tsStartLongitude,
    String? tsEndLatitude,
    String? tsEndLongitude,
    String? tsStatus,
    int? tsParentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? submitterUser,


    List<TaskSubmissionCommentModel>? submissionComments,
    AttachmentsCategories? submissionAttachmentsCategories,
    int? commentsCount,
    TaskModel? taskDetails,
  }) {
    return TaskSubmissionModel(
      tsId: tsId ?? this.tsId,
      tsTaskId: tsTaskId ?? this.tsTaskId,
      tsSubmitter: tsSubmitter ?? this.tsSubmitter,
      tsContent: tsContent ?? this.tsContent,
      tsActualStartTime: tsActualStartTime ?? this.tsActualStartTime,
      tsActualEndTime: tsActualEndTime ?? this.tsActualEndTime,
      tsStartLatitude: tsStartLatitude ?? this.tsStartLatitude,
      tsStartLongitude: tsStartLongitude ?? this.tsStartLongitude,
      tsEndLatitude: tsEndLatitude ?? this.tsEndLatitude,
      tsEndLongitude: tsEndLongitude ?? this.tsEndLongitude,
      tsStatus: tsStatus ?? this.tsStatus,
      tsParentId: tsParentId ?? this.tsParentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      submitterUser: submitterUser ?? this.submitterUser,
      submissionComments: submissionComments ?? this.submissionComments,
      submissionAttachmentsCategories: submissionAttachmentsCategories ??
          this.submissionAttachmentsCategories,
      commentsCount: commentsCount ?? this.commentsCount,
      taskDetails: taskDetails ?? this.taskDetails,
    );
  }

  factory TaskSubmissionModel.fromMap(Map<String, dynamic> json) =>
      TaskSubmissionModel(
        tsId: json["ts_id"],
        tsTaskId: json["ts_task_id"],
        tsSubmitter: json["ts_submitter"],
        tsContent: json["ts_content"],
        tsActualStartTime: json["ts_actual_start_time"] == null
            ? null
            : DateTime.parse(json["ts_actual_start_time"]),
        tsActualEndTime: json["ts_actual_end_time"] == null
            ? null
            : DateTime.parse(json["ts_actual_end_time"]),
        tsStartLatitude: json["ts_start_latitude"],
        tsStartLongitude: json["ts_start_longitude"],
        tsEndLatitude: json["ts_end_latitude"],
        tsEndLongitude: json["ts_end_longitude"],
        tsStatus: json["ts_status"],
        tsParentId: json["ts_parent_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        submitterUser: json["submitter_user"] == null
            ? null
            : UserModel.fromMap(json["submitter_user"]),
        submissionComments: json["submission_comments"] == null
            ? []
            : List<TaskSubmissionCommentModel>.from(json["submission_comments"]!
                .map((x) => TaskSubmissionCommentModel.fromMap(x))),
        submissionAttachmentsCategories:
            json["submission_attachments_categories"] == null
                ? null
                : AttachmentsCategories.fromMap(
                    json["submission_attachments_categories"]),
        commentsCount: json["comments_count"],
        taskDetails: json["task_details"] == null
            ? null
            : TaskModel.fromMap(json["task_details"]),
      );

  Map<String, dynamic> toMap() => {
        "ts_id": tsId,
        "ts_task_id": tsTaskId,
        "ts_submitter": tsSubmitter,
        "ts_content": tsContent,
        "ts_actual_start_time": tsActualStartTime?.toIso8601String(),
        "ts_actual_end_time": tsActualEndTime?.toIso8601String(),
        // "ts_file": tsFile,
        "ts_start_latitude": tsStartLatitude,
        "ts_start_longitude": tsStartLongitude,
        "ts_end_latitude": tsEndLatitude,
        "ts_end_longitude": tsEndLongitude,
        "ts_status": tsStatus,
        "ts_parent_id": tsParentId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "submitter_user": submitterUser?.toMap(),
        "submission_comments": submissionComments == null
            ? []
            : List<dynamic>.from(submissionComments!.map((x) => x.toMap())),
        "submission_attachments_categories":
            submissionAttachmentsCategories?.toMap(),
        "comments_count": commentsCount,
        "task_details": taskDetails?.toMap(),
      };
}
