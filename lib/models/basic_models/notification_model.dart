class NotificationModel {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final int? isRead;
  final String? type;
  final int? typeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.isRead,
    this.type,
    this.typeId,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    body: json["body"],
    isRead: json["is_read"],
    type: json["type"],
    typeId: json["type_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "body": body,
    "is_read": isRead,
    "type": type,
    "type_id": typeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
