import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class UserLoginModel {
  final bool? status;
  final String? message;
  final UserModel? user;
  final String? token;

  UserLoginModel({
    this.status,
    this.message,
    this.user,
    this.token,
  });

  factory UserLoginModel.fromMap(Map<String, dynamic> json) => UserLoginModel(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "user": user?.toMap(),
    "token": token,
  };
}
