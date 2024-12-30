import 'package:jelanco_tracking_system/models/basic_models/role_model.dart';

class AddEditRoleModel {
  final bool? status;
  final String? message;
  final RoleModel? role;

  AddEditRoleModel({
    this.status,
    this.message,
    this.role,
  });

  factory AddEditRoleModel.fromMap(Map<String, dynamic> json) => AddEditRoleModel(
    status: json["status"],
    message: json["message"],
    role: json["role"] == null ? null : RoleModel.fromMap(json["role"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "role": role?.toMap(),
  };
}
