class GetSubmissionCommentCountModel {
  final bool? status;
  final int? commentsCount;

  GetSubmissionCommentCountModel({
    this.status,
    this.commentsCount,
  });

  factory GetSubmissionCommentCountModel.fromMap(Map<String, dynamic> json) => GetSubmissionCommentCountModel(
    status: json["status"],
    commentsCount: json["comments_count"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "comments_count": commentsCount,
  };
}
