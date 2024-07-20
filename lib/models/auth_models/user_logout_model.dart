class UserLogoutModel {
  final bool? status;
  final String? message;

  UserLogoutModel({
    this.status,
    this.message,
  });

  factory UserLogoutModel.fromMap(Map<String, dynamic> json) => UserLogoutModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
  };
}
