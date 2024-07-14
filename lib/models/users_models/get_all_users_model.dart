import '../basic_models/user_model.dart';

class GetAllUsersModel {
  final bool? status;
  final List<UserModel>? users;

  GetAllUsersModel({
    this.status,
    this.users,
  });

  factory GetAllUsersModel.fromMap(Map<String, dynamic> json) => GetAllUsersModel(
    status: json["status"],
    users: json["users"] == null ? [] : List<UserModel>.from(json["users"]!.map((x) => UserModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toMap())),
  };
}

