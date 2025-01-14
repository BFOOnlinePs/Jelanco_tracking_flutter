import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/files_list_view_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_media_viewer.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_thumbnail_video.dart';

class CommentMediaWidget extends StatelessWidget {
  final TaskSubmissionCommentModel comment;

  const CommentMediaWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return comment.commentAttachmentsCategories!.files!.isNotEmpty ||
            comment.commentAttachmentsCategories!.videos!.isNotEmpty ||
            comment.commentAttachmentsCategories!.images!.isNotEmpty
        ? Container(
            // padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                comment.commentAttachmentsCategories!.files!.isNotEmpty
                    ? FilesListViewWidget(
                        storagePath:
                            EndPointsConstants.taskSubmissionsCommentStorage,
                        files: comment.commentAttachmentsCategories!.files,
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                comment.commentAttachmentsCategories!.images!.isNotEmpty ||
                        comment.commentAttachmentsCategories!.videos!.isNotEmpty
                    ? SizedBox(
                        height: 220.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: comment.commentAttachmentsCategories!
                                  .images!.length +
                              comment
                                  .commentAttachmentsCategories!.videos!.length,
                          itemBuilder: (context, index) {
                            // Determine if the current item is an image or a video
                            if (index <
                                comment.commentAttachmentsCategories!.images!
                                    .length) {
                              // This is an image
                              return MyImage(
                                height: 200,
                                margin:
                                    const EdgeInsetsDirectional.only(end: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyMediaViewer(
                                          storagePath: EndPointsConstants
                                              .taskSubmissionsCommentStorage,
                                          mediaList: comment
                                              .commentAttachmentsCategories!
                                              .images!
                                              .map((image) => MediaItem(
                                                  type: MediaType.image,
                                                  url: image.aAttachment!))
                                              .toList()
                                            ..addAll(comment
                                                .commentAttachmentsCategories!
                                                .videos!
                                                .map((video) => MediaItem(
                                                    type: MediaType.video,
                                                    url: video.aAttachment!))),
                                          startIndex:
                                              index, // Start at the tapped image index
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 220,
                                    width: 132,
                                    child: MyCachedNetworkImage(
                                      imageUrl: EndPointsConstants
                                              .taskSubmissionsCommentStorage +
                                          comment.commentAttachmentsCategories!
                                              .images![index].aAttachment!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // This is a video
                              int videoIndex = index -
                                  comment.commentAttachmentsCategories!.images!
                                      .length;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyMediaViewer(
                                        storagePath: EndPointsConstants
                                            .taskSubmissionsCommentStorage,
                                        mediaList: comment
                                            .commentAttachmentsCategories!
                                            .images!
                                            .map((image) => MediaItem(
                                                type: MediaType.image,
                                                url: image.aAttachment!))
                                            .toList()
                                          ..addAll(comment
                                              .commentAttachmentsCategories!
                                              .videos!
                                              .map((video) => MediaItem(
                                                  type: MediaType.video,
                                                  url: video.aAttachment!))),
                                        startIndex:
                                            index, // Start at the tapped video index
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 220,
                                  width: 132,
                                  margin:
                                      const EdgeInsetsDirectional.only(end: 8),
                                  child: Stack(
                                    children: [
                                      MyThumbnailVideo(
                                        index: videoIndex,
                                        height: 220,
                                        showVideoIcon: true,
                                        thumbnail: comment
                                                    .commentAttachmentsCategories!
                                                    .videos![videoIndex]
                                                    .thumbnail !=
                                                null
                                            ? MyCachedNetworkImage(
                                                imageUrl: EndPointsConstants
                                                        .thumbnailStorage +
                                                    comment
                                                        .commentAttachmentsCategories!
                                                        .videos![videoIndex]
                                                        .thumbnail!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                AssetsKeys
                                                    .defaultVideoThumbnail,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        : Container();
  }
}
