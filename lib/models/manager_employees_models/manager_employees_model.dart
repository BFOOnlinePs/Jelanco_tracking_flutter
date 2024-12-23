import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

// GetManagerEmployeesModel + GetManagerEmployeesModelById + GetManagerEmployeesWithTaskAssigneesModel
class GetManagerEmployeesModel {
  final bool? status;
  final List<int>? userManagerIds;
  final List<UserModel>? managerEmployees;

  GetManagerEmployeesModel({
    this.status,
    this.userManagerIds,
    this.managerEmployees,
  });

  factory GetManagerEmployeesModel.fromMap(Map<String, dynamic> json) => GetManagerEmployeesModel(
        status: json["status"],
        userManagerIds: json["user_manager_ids"] == null ? [] : List<int>.from(json["user_manager_ids"]!.map((x) => x)),
        managerEmployees:
            json["manager_employees"] == null ? [] : List<UserModel>.from(json["manager_employees"]!.map((x) => UserModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "user_manager_ids": userManagerIds == null ? [] : List<dynamic>.from(userManagerIds!.map((x) => x)),
        "manager_employees": managerEmployees == null ? [] : List<dynamic>.from(managerEmployees!.map((x) => x.toMap())),
      };
}
