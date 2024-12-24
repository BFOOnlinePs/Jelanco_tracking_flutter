class StatusMessageModel {
  final bool? status;
  final String? message;

  StatusMessageModel({
    this.status,
    this.message,
  });

  factory StatusMessageModel.fromMap(Map<String, dynamic> json) => StatusMessageModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
  };
}
