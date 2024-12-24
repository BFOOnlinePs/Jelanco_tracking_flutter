import 'package:jelanco_tracking_system/models/basic_models/pagination_model.dart';

import '../basic_models/user_model.dart';

class GetAllUsersModel {
  final bool? status;
  final PaginationModel? pagination;
  final List<UserModel>? users;

  GetAllUsersModel({
    this.status,
    this.users,
    this.pagination,
  });

  factory GetAllUsersModel.fromMap(Map<String, dynamic> json) => GetAllUsersModel(
        status: json["status"],
        pagination: json["pagination"] == null ? null : PaginationModel.fromMap(json["pagination"]),
        users: json["users"] == null ? [] : List<UserModel>.from(json["users"]!.map((x) => UserModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "pagination": pagination?.toMap(),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toMap())),
      };
}
