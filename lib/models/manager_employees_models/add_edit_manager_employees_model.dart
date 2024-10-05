class AddEditManagerEmployeesModel {
  final bool? status;
  final String? message;

  AddEditManagerEmployeesModel({
    this.status,
    this.message,
  });

  factory AddEditManagerEmployeesModel.fromMap(Map<String, dynamic> json) => AddEditManagerEmployeesModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
      };
}
