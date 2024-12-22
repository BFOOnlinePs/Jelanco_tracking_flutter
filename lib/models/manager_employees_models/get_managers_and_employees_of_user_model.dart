class GetManagersAndEmployeesOfUserModel {
  final bool? status;
  final List<int>? managerIds;
  final List<int>? employeeIds;

  GetManagersAndEmployeesOfUserModel({
    this.status,
    this.managerIds,
    this.employeeIds,
  });

  factory GetManagersAndEmployeesOfUserModel.fromMap(Map<String, dynamic> json) => GetManagersAndEmployeesOfUserModel(
    status: json["status"],
    managerIds: json["manager_ids"] == null ? [] : List<int>.from(json["manager_ids"]!.map((x) => x)),
    employeeIds: json["employee_ids"] == null ? [] : List<int>.from(json["employee_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "manager_ids": managerIds == null ? [] : List<dynamic>.from(managerIds!.map((x) => x)),
    "employee_ids": employeeIds == null ? [] : List<dynamic>.from(employeeIds!.map((x) => x)),
  };
}
