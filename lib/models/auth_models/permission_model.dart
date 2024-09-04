import 'package:jelanco_tracking_system/models/auth_models/role_has_permissions_model.dart';

class PermissionModel {
  final int? id;
  final String? name;
  final String? guardName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RoleHasPermissionsModel? pivot;

  PermissionModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory PermissionModel.fromMap(Map<String, dynamic> json) => PermissionModel(
    id: json["id"],
    name: json["name"],
    guardName: json["guard_name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    pivot: json["pivot"] == null ? null : RoleHasPermissionsModel.fromMap(json["pivot"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "guard_name": guardName,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pivot": pivot?.toMap(),
  };
}

