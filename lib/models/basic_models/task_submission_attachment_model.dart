import 'package:video_player/video_player.dart';

class SubmissionAttachmentModel {
  final int? aId;
  final String? aTable;
  final int? aFkId;
  final String? aAttachment;
  final String? thumbnail;
  final int? aUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  late VideoPlayerController? videoController;

  SubmissionAttachmentModel({
    this.aId,
    this.aTable,
    this.aFkId,
    this.aAttachment,
    this.thumbnail,
    this.aUserId,
    this.createdAt,
    this.updatedAt,
    this.videoController,
  });

  factory SubmissionAttachmentModel.fromMap(Map<String, dynamic> json) =>
      SubmissionAttachmentModel(
        aId: json["a_id"],
        aTable: json["a_table"],
        aFkId: json["a_fk_id"],
        aAttachment: json["a_attachment"],
        thumbnail: json["thumbnail"],
        aUserId: json["a_user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "a_id": aId,
        "a_table": aTable,
        "a_fk_id": aFkId,
        "a_attachment": aAttachment,
        "thumbnail": thumbnail,
        "a_user_id": aUserId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
