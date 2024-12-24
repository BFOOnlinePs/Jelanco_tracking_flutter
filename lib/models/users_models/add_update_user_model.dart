import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class AddUpdateUserModel {
  final bool? status;
  final String? message;
  final UserModel? user;

  AddUpdateUserModel({
    this.status,
    this.message,
    this.user,
  });

  factory AddUpdateUserModel.fromMap(Map<String, dynamic> json) => AddUpdateUserModel(
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

