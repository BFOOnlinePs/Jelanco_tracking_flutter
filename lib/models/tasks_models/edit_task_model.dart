class EditTaskModel {
  final bool? status;
  final String? message;

  EditTaskModel({
    this.status,
    this.message,
  });

  factory EditTaskModel.fromMap(Map<String, dynamic> json) => EditTaskModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
  };
}
