class DepartmentModel {
  final int? dId;
  final String? dName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DepartmentModel({
    this.dId,
    this.dName,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> json) => DepartmentModel(
    dId: json["d_id"],
    dName: json["d_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "d_id": dId,
    "d_name": dName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
