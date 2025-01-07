class GetUserRoleAndPermissionsIdsModel {
  final List<int>? roleIds;
  final List<int>? directPermissionIds;

  GetUserRoleAndPermissionsIdsModel({this.roleIds, this.directPermissionIds});

  factory GetUserRoleAndPermissionsIdsModel.fromMap(Map<String, dynamic> json) => GetUserRoleAndPermissionsIdsModel(
        roleIds: json["role_ids"] == null ? [] : List<int>.from(json["role_ids"]!.map((x) => x)),
        directPermissionIds: json["direct_permission_ids"] == null ? [] : List<int>.from(json["direct_permission_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "role_ids": roleIds == null ? [] : List<dynamic>.from(roleIds!.map((x) => x)),
        "direct_permission_ids": directPermissionIds == null ? [] : List<dynamic>.from(directPermissionIds!.map((x) => x)),
      };
}
