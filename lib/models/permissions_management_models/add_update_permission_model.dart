import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';

class AddUpdatePermissionModel {
  final bool? status;
  final String? message;
  final PermissionModel? permission;

  AddUpdatePermissionModel({
    this.status,
    this.message,
    this.permission,
  });

  factory AddUpdatePermissionModel.fromMap(Map<String, dynamic> json) => AddUpdatePermissionModel(
        status: json["status"],
        message: json["message"],
        permission: json["permission"] == null ? null : PermissionModel.fromMap(json["permission"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "permission": permission?.toMap(),
      };
}
