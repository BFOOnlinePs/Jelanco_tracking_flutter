import 'package:jelanco_tracking_system/models/basic_models/task_submission_attachment_model.dart';

class SubmissionAttachmentsCategories {
  final List<SubmissionAttachmentModel>? images;
  final List<SubmissionAttachmentModel>? videos;
  final List<SubmissionAttachmentModel>? files;

  SubmissionAttachmentsCategories({
    this.images,
    this.videos,
    this.files,
  });

  factory SubmissionAttachmentsCategories.fromMap(Map<String, dynamic> json) => SubmissionAttachmentsCategories(
    images: json["images"] == null ? [] : List<SubmissionAttachmentModel>.from(json["images"]!.map((x) => SubmissionAttachmentModel.fromMap(x))),
    videos: json["videos"] == null ? [] : List<SubmissionAttachmentModel>.from(json["videos"]!.map((x) => SubmissionAttachmentModel.fromMap(x))),
    files: json["files"] == null ? [] : List<SubmissionAttachmentModel>.from(json["files"]!.map((x) => SubmissionAttachmentModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toMap())),
    "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toMap())),
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toMap())),
  };
}