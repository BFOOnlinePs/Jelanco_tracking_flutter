class AddTaskModel {
  final bool? status;
  final String? message;

  AddTaskModel({
    this.status,
    this.message,
  });

  factory AddTaskModel.fromMap(Map<String, dynamic> json) => AddTaskModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
  };
}