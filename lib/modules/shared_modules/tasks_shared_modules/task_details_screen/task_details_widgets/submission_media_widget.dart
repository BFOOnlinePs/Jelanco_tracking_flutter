import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/launch_url_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/videos_modules/video_player_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_thumbnail_video.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video_view.dart';

class SubmissionMediaWidget extends StatelessWidget {
  final TaskSubmissionModel submission;
  final TaskDetailsCubit? taskDetailsCubit;

  const SubmissionMediaWidget({
    super.key,
    required this.submission,
    this.taskDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        submission.submissionAttachmentsCategories!.files!.isNotEmpty
            ? Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      submission.submissionAttachmentsCategories!.files!.length,
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () {
                      LaunchUrlUtils.launchMyUrl(
                          storagePath:
                              EndPointsConstants.taskSubmissionsStorage,
                          uriString: submission.submissionAttachmentsCategories!
                              .files![index].aAttachment!);
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    splashColor: Colors.blue.withOpacity(0.2),
                    highlightColor: Colors.blue.withOpacity(0.1),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: ColorsConstants.primaryColor,
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(
                            CardSizeConstants.mediaRadius),
                        boxShadow: const [
                          BoxShadow(
                            color: ColorsConstants.primaryColor,
                            spreadRadius: 1,
                            blurRadius: 4,
                            // offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const FaIcon(FontAwesomeIcons.fileLines,
                          color: ColorsConstants.primaryColor, size: 30.0),

                      // Text(
                      //   'ملف رقم ${index + 1}',
                      //   style: TextStyle(
                      //     color: ColorsConstants.primaryColor,
                      //     fontSize: 12.0,
                      //     fontWeight: FontWeight.bold,
                      //     decoration: TextDecoration.underline,
                      //     shadows: [
                      //       Shadow(
                      //         color: Colors.black.withOpacity(0.2),
                      //         offset: Offset(1, 1),
                      //         blurRadius: 2,
                      //       ),
                      //     ], // Subtle shadow
                      //   ),
                      // ),
                    ),
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        submission.submissionAttachmentsCategories!.images!.isNotEmpty
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
                                galleryItems: submission
                                    .submissionAttachmentsCategories!.images!
                                    .map((image) => image.aAttachment!)
                                    .toList(),
                                imagesHostPath:
                                    '${EndPointsConstants.taskSubmissionsStorage}',
                                startedIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Image(
                          image: NetworkImage(
                            '${EndPointsConstants.taskSubmissionsStorage}${submission.submissionAttachmentsCategories!.images![index].aAttachment}',
                          ),
                          // fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  itemCount: submission
                      .submissionAttachmentsCategories!.images!.length,
                ),
              )
            : Container(),
        const SizedBox(height: 8.0),
        submission.submissionAttachmentsCategories!.videos!.isNotEmpty
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
                            builder: (context) => HorizontalVideoViewer(
                              storagePath:
                                  EndPointsConstants.taskSubmissionsStorage,
                              videoUrls: submission
                                  .submissionAttachmentsCategories!.videos!
                                  .map((video) {
                                return video.aAttachment!;
                              }).toList(),
                              startIndex: index,
                            ),
                            //     VideoPlayerScreen(
                            //   videoUrl:
                            //       '${EndPointsConstants.taskSubmissionsStorage}${submission.submissionAttachmentsCategories!.videos![index].aAttachment!}',
                            // ),
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
                              thumbnail: submission
                                          .submissionAttachmentsCategories!
                                          .videos![index]
                                          .thumbnail !=
                                      null
                                  ? Image.network(
                                      EndPointsConstants.thumbnailStorage +
                                          submission
                                              .submissionAttachmentsCategories!
                                              .videos![index]
                                              .thumbnail!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      AssetsKeys.defaultVideoThumbnail,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            // // Video thumbnail image
                            // Positioned.fill(
                            //   child: submission.submissionAttachmentsCategories!
                            //               .videos![index].thumbnail !=
                            //           null
                            //       ? Image.network(
                            //           EndPointsConstants.thumbnailStorage +
                            //               submission
                            //                   .submissionAttachmentsCategories!
                            //                   .videos![index]
                            //                   .thumbnail!,
                            //           fit: BoxFit.cover,
                            //         )
                            //       : Image.asset(
                            //           AssetsKeys.defaultVideoThumbnail,
                            //           fit: BoxFit.cover,
                            //         ),
                            // ),
                            // // Play icon overlay
                            // Center(
                            //   child: Icon(
                            //     Icons.play_circle_fill,
                            //     color: Colors.white,
                            //     size: 50.0,
                            //   ),
                            // ),
                            // Duration overlay
                            // Positioned(
                            //   bottom: 8.0,
                            //   right: 8.0,
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 8.0, vertical: 4.0),
                            //     color: Colors.black.withOpacity(0.7),
                            //     child: Text(
                            //       'duration',
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: submission
                      .submissionAttachmentsCategories!.videos!.length,
                ),
              )
            : Container(),
      ],
    );
  }
}
