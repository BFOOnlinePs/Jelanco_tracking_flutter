import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class InterestedPartyModel {
  final int? ipId;
  final String? ipArticleType;
  final int? ipArticleId;
  final int? ipInterestedPartyId;
  final int? ipAddedById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user; // interested party
  final UserModel? addedByUser;
  final TaskModel? task;
  final TaskSubmissionModel? submission;

  InterestedPartyModel({
    this.ipId,
    this.ipArticleType,
    this.ipArticleId,
    this.ipInterestedPartyId,
    this.ipAddedById,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.addedByUser,
    this.task,
    this.submission,
  });

  factory InterestedPartyModel.fromMap(Map<String, dynamic> json) => InterestedPartyModel(
        ipId: json["ip_id"],
        ipArticleType: json["ip_article_type"],
        ipArticleId: json["ip_article_id"],
        ipInterestedPartyId: json["ip_interested_party_id"],
        ipAddedById: json["ip_added_by_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        addedByUser: json["added_by_user"] == null ? null : UserModel.fromMap(json["added_by_user"]),
        task: json["task"] == null ? null : TaskModel.fromMap(json["task"]),
        submission: json["submission"] == null ? null : TaskSubmissionModel.fromMap(json["submission"]),
      );

  Map<String, dynamic> toMap() => {
        "ip_id": ipId,
        "ip_article_type": ipArticleType,
        "ip_article_id": ipArticleId,
        "ip_interested_party_id": ipInterestedPartyId,
        "ip_added_by_id": ipAddedById,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toMap(),
        "added_by_user": addedByUser?.toMap(),
        "task": task?.toMap(),
        "submission": submission?.toMap(),
      };
}
