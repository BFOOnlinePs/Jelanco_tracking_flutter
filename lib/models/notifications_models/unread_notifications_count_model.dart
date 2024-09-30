class UnreadNotificationsCountModel {
  final bool? status;
  int? unreadNotificationsCount;

  UnreadNotificationsCountModel({
    this.status,
    this.unreadNotificationsCount,
  });

  factory UnreadNotificationsCountModel.fromMap(Map<String, dynamic> json) => UnreadNotificationsCountModel(
    status: json["status"],
    unreadNotificationsCount: json["unread_notifications_count"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "unread_notifications_count": unreadNotificationsCount,
  };
}
