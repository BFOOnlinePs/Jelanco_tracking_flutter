import 'package:jelanco_tracking_system/models/basic_models/role_model.dart';

class GetAllRolesWithPermissionsModel {
  final List<RoleModel>? roles;

  GetAllRolesWithPermissionsModel({
    this.roles,
  });

  factory GetAllRolesWithPermissionsModel.fromMap(Map<String, dynamic> json) => GetAllRolesWithPermissionsModel(
        roles: json["roles"] == null ? [] : List<RoleModel>.from(json["roles"]!.map((x) => RoleModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toMap())),
      };
}
