import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';

class GetDepartmentsModel {
  final bool? status;
  final List<DepartmentModel>? departments;

  GetDepartmentsModel({
    this.status,
    this.departments,
  });

  factory GetDepartmentsModel.fromMap(Map<String, dynamic> json) => GetDepartmentsModel(
    status: json["status"],
    departments: json["departments"] == null ? [] : List<DepartmentModel>.from(json["departments"]!.map((x) => DepartmentModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "departments": departments == null ? [] : List<dynamic>.from(departments!.map((x) => x.toMap())),
  };
}

