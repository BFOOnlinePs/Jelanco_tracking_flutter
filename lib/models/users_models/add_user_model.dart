import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class AddUserModel {
  final bool? status;
  final String? message;
  final UserModel? user;

  AddUserModel({
    this.status,
    this.message,
    this.user,
  });

  factory AddUserModel.fromMap(Map<String, dynamic> json) => AddUserModel(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "user": user?.toMap(),
  };
}

