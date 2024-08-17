import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/videos_modules/video_player_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_thumbnail_video.dart';

class CommentMediaWidget extends StatelessWidget {
  final TaskSubmissionCommentModel comment;
  final TaskDetailsCubit taskDetailsCubit;

  const CommentMediaWidget({
    super.key,
    required this.comment,
    required this.taskDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        comment.commentAttachmentsCategories!.files!.isNotEmpty
            ? Column(
                children: [
                  ...comment.commentAttachmentsCategories!.files!
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final file = entry.value;

                    return InkWell(
                      onTap: () {
                        taskDetailsCubit.launchMyUrl(
                            storagePath:
                                EndPointsConstants.taskSubmissionsCommentStorage,
                            uriString: file.aAttachment!);
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      splashColor: Colors.blue.withOpacity(0.2),
                      highlightColor: Colors.blue.withOpacity(0.1),
                      child: Container(
                        padding: EdgeInsets.all(8.0), // Add padding
                        child: Text(
                          'ملف رقم ${index + 1}',
                          style: TextStyle(
                            color: ColorsConstants.primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ], // Subtle shadow
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              )
            : Container(),
        comment.commentAttachmentsCategories!.videos!.isNotEmpty
            ? Container(
                height: 200,
                child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl:
                                  '${EndPointsConstants.taskSubmissionsStorage}${comment.commentAttachmentsCategories!.videos![index].aAttachment!}',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 132,
                        child: Stack(
                          children: [
                            MyThumbnailVideo(
                              margin: EdgeInsetsDirectional.only(end: 8),
                              index: index,
                              height: 200,
                              showVideoIcon: true,
                              thumbnail: comment.commentAttachmentsCategories!
                                          .videos![index].thumbnail !=
                                      null
                                  ? Image.network(
                                      EndPointsConstants.thumbnailStorage +
                                          comment.commentAttachmentsCategories!
                                              .videos![index].thumbnail!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      AssetsKeys.defaultVideoThumbnail,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount:
                      comment.commentAttachmentsCategories!.videos!.length,
                ),
              )
            : Container(),
        SizedBox(height: 8.0),
        comment.commentAttachmentsCategories!.images!.isNotEmpty
            ? Container(
                height: 220.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return MyImage(
                      height: 200,
                      margin: EdgeInsetsDirectional.only(end: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPhotoView(
                                galleryItems: comment
                                    .commentAttachmentsCategories!.images!
                                    .map((image) => image.aAttachment!)
                                    .toList(),
                                imagesHostPath:
                                    '${EndPointsConstants.taskSubmissionsCommentStorage}',
                                startedIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Image(
                          image: NetworkImage(
                            '${EndPointsConstants.taskSubmissionsCommentStorage}${comment.commentAttachmentsCategories!.images![index].aAttachment}',
                          ),
                          // fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  itemCount:
                      comment.commentAttachmentsCategories!.images!.length,
                ),
              )
            : Container(),
      ],
    );
  }
}
