import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';

class GetManagerEmployeesModel {
  final bool? status;
  final List<UserModel>? managerEmployees;

  GetManagerEmployeesModel({
    this.status,
    this.managerEmployees,
  });

  factory GetManagerEmployeesModel.fromMap(Map<String, dynamic> json) =>
      GetManagerEmployeesModel(
        status: json["status"],
        managerEmployees: json["manager_employees"] == null
            ? []
            : List<UserModel>.from(
                json["manager_employees"]!.map((x) => UserModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "manager_employees": managerEmployees == null
            ? []
            : List<dynamic>.from(managerEmployees!.map((x) => x.toMap())),
      };
}
