import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class GetUserByIdModel {
  final bool? status;
  final UserModel? user;
  final List<PermissionModel>? permissions;

  GetUserByIdModel({
    this.status,
    this.user,
    this.permissions,
  });

  factory GetUserByIdModel.fromMap(Map<String, dynamic> json) =>
      GetUserByIdModel(
        status: json["status"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        permissions: json["permissions"] == null
            ? []
            : List<PermissionModel>.from(
                json["permissions"]!.map((x) => PermissionModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "user": user?.toMap(),
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toMap())),
      };
}
