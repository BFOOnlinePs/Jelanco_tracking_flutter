class TaskCategoryModel {
  final int? cId;
  final String? cName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskCategoryModel({
    this.cId,
    this.cName,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskCategoryModel.fromMap(Map<String, dynamic> json) => TaskCategoryModel(
    cId: json["c_id"],
    cName: json["c_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "c_id": cId,
    "c_name": cName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
