import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class UserLoginModel {
  final bool? status;
  final String? message;
  final UserModel? user;
  final String? token;
  final List<PermissionModel>? permissions;

  UserLoginModel({
    this.status,
    this.message,
    this.user,
    this.token,
    this.permissions,
  });

  factory UserLoginModel.fromMap(Map<String, dynamic> json) => UserLoginModel(
        status: json["status"],
        message: json["message"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        token: json["token"],
        permissions:
            json["permissions"] == null ? [] : List<PermissionModel>.from(json["permissions"]!.map((x) => PermissionModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "user": user?.toMap(),
        "token": token,
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x.toMap())),
      };
}
