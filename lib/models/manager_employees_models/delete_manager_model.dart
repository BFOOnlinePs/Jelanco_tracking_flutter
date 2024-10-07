class DeleteManagerModel {
  final bool? status;
  final String? message;

  DeleteManagerModel({
    this.status,
    this.message,
  });

  factory DeleteManagerModel.fromMap(Map<String, dynamic> json) => DeleteManagerModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
      };
}
