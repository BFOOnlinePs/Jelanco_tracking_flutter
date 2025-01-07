import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';

class RoleModel {
  final int? id;
  String? name;
  final String? guardName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PermissionModel>? permissions;
  final Pivot? pivot;

  RoleModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.pivot,
  });

  factory RoleModel.fromMap(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        permissions:
            json["permissions"] == null ? [] : List<PermissionModel>.from(json["permissions"]!.map((x) => PermissionModel.fromMap(x))),
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toMap())),
        "pivot": pivot?.toMap(),
      };
}

class Pivot {
  final int? roleId;
  final int? permissionId;

  Pivot({
    this.roleId,
    this.permissionId,
  });

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        roleId: json["role_id"],
        permissionId: json["permission_id"],
      );

  Map<String, dynamic> toMap() => {
        "role_id": roleId,
        "permission_id": permissionId,
      };
}
