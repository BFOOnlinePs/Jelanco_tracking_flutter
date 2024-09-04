class RoleHasPermissionsModel {
  final int? roleId;
  final int? permissionId;

  RoleHasPermissionsModel({
    this.roleId,
    this.permissionId,
  });

  factory RoleHasPermissionsModel.fromMap(Map<String, dynamic> json) =>
      RoleHasPermissionsModel(
        roleId: json["role_id"],
        permissionId: json["permission_id"],
      );

  Map<String, dynamic> toMap() => {
        "role_id": roleId,
        "permission_id": permissionId,
      };
}
