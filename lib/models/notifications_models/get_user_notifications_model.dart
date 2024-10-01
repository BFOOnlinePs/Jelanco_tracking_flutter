import 'package:jelanco_tracking_system/models/basic_models/notification_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';

class GetUserNotificationsModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<NotificationModel>? notifications;

  GetUserNotificationsModel({
    this.status,
    this.pagination,
    this.notifications,
  });

  factory GetUserNotificationsModel.fromMap(Map<String, dynamic> json) => GetUserNotificationsModel(
    status: json["status"],
    pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
    notifications: json["notifications"] == null ? [] : List<NotificationModel>.from(json["notifications"]!.map((x) => NotificationModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "pagination": pagination?.toMap(),
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toMap())),
  };
}