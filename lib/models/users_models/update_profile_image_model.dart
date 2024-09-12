class UpdateProfileImageModel {
  final bool? status;
  final String? message;
  final String? imageUrl;

  UpdateProfileImageModel({
    this.status,
    this.message,
    this.imageUrl,
  });

  factory UpdateProfileImageModel.fromMap(Map<String, dynamic> json) => UpdateProfileImageModel(
    status: json["status"],
    message: json["message"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "image_url": imageUrl,
  };
}
