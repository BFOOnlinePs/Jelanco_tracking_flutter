import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/files_list_view_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_media_viewer.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_thumbnail_video.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class MediaWidget extends StatelessWidget {
  final AttachmentsCategories? attachmentsCategories;
  final String storagePath;

  const MediaWidget({
    super.key,
    required this.attachmentsCategories,
    required this.storagePath,
  });

  @override
  Widget build(BuildContext context) {
    return attachmentsCategories == null
        ? Container()
        : Container(
            margin: attachmentsCategories!.files!.isNotEmpty ||
                    attachmentsCategories!.images!.isNotEmpty ||
                    attachmentsCategories!.videos!.isNotEmpty
                ? const EdgeInsets.symmetric(vertical: 6)
                : EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                attachmentsCategories!.files!.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: FilesListViewWidget(
                          storagePath: storagePath,
                          files: attachmentsCategories!.files,
                        ),
                      )
                    : Container(),

                attachmentsCategories!.images!.isNotEmpty || attachmentsCategories!.videos!.isNotEmpty
                    ? SizedBox(
                        height: 220.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              attachmentsCategories!.images!.length + attachmentsCategories!.videos!.length,
                          itemBuilder: (context, index) {
                            // Determine if the current item is an image or a video
                            if (index < attachmentsCategories!.images!.length) {
                              // This is an image
                              return MyImage(
                                height: 200,
                                margin: const EdgeInsetsDirectional.only(end: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyMediaViewer(
                                          storagePath: storagePath,
                                          mediaList: attachmentsCategories!.images!
                                              .map((image) =>
                                                  MediaItem(type: MediaType.image, url: image.aAttachment!))
                                              .toList()
                                            ..addAll(attachmentsCategories!.videos!.map((video) =>
                                                MediaItem(type: MediaType.video, url: video.aAttachment!))),
                                          startIndex: index, // Start at the tapped image index
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 220,
                                    width: 132,
                                    child: MyCachedNetworkImage(
                                      imageUrl:
                                          '$storagePath${attachmentsCategories!.images![index].aAttachment}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // This is a video
                              int videoIndex = index - attachmentsCategories!.images!.length;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyMediaViewer(
                                        storagePath: storagePath,
                                        mediaList: attachmentsCategories!.images!
                                            .map((image) =>
                                                MediaItem(type: MediaType.image, url: image.aAttachment!))
                                            .toList()
                                          ..addAll(attachmentsCategories!.videos!.map((video) =>
                                              MediaItem(type: MediaType.video, url: video.aAttachment!))),
                                        startIndex: index, // Start at the tapped video index
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 220,
                                  width: 132,
                                  margin: const EdgeInsetsDirectional.only(end: 8),
                                  child: Stack(
                                    children: [
                                      MyThumbnailVideo(
                                        index: videoIndex,
                                        height: 220,
                                        showVideoIcon: true,
                                        thumbnail:
                                            attachmentsCategories!.videos![videoIndex].thumbnail != null
                                                ? MyCachedNetworkImage(
                                                    imageUrl: EndPointsConstants.thumbnailStorage +
                                                        attachmentsCategories!.videos![videoIndex].thumbnail!,
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
                            }
                          },
                        ),
                      )
                    : Container(),

                // separated image and video view (may i need later)

                // attachmentsCategories!.images!.isNotEmpty
                //     ? Container(
                //         height: 220.0,
                //         child: ListView.builder(
                //             scrollDirection: Axis.horizontal,
                //             itemBuilder: (context, index) {
                //               return MyImage(
                //                 height: 200,
                //                 margin: EdgeInsetsDirectional.only(end: 8),
                //                 child: GestureDetector(
                //                   onTap: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(
                //                         builder: (context) => MyPhotoView(
                //                           imagesUrls: submission
                //                               .submissionAttachmentsCategories!.images!
                //                               .map((image) => image.aAttachment!)
                //                               .toList(),
                //                           storagePath:
                //                               EndPointsConstants.taskSubmissionsStorage,
                //                           startedIndex: index,
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                   child: Image(
                //                     image: NetworkImage(
                //                       '${EndPointsConstants.taskSubmissionsStorage}${attachmentsCategories!.images![index].aAttachment}',
                //                     ),
                //                     // fit: BoxFit.cover,
                //                   ),
                //                 ),
                //               );
                //             },
                //             itemCount: submission
                //                 .submissionAttachmentsCategories!.images!.length
                //             // +
                //             // submission
                //             //     .submissionAttachmentsCategories!.videos!.length,
                //             ),
                //       )
                //     : Container(),
                // const SizedBox(height: 8.0),
                // attachmentsCategories!.videos!.isNotEmpty
                //     ? Container(
                //         height: 200,
                //         child: ListView.builder(
                //           // shrinkWrap: true,
                //           // physics: NeverScrollableScrollPhysics(),
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: (context, index) {
                //             return GestureDetector(
                //               onTap: () {
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) => HorizontalVideoViewer(
                //                       storagePath:
                //                           EndPointsConstants.taskSubmissionsStorage,
                //                       videoUrls: submission
                //                           .submissionAttachmentsCategories!.videos!
                //                           .map((video) {
                //                         return video.aAttachment!;
                //                       }).toList(),
                //                       startIndex: index,
                //                     ),
                //                     //     VideoPlayerScreen(
                //                     //   videoUrl:
                //                     //       '${EndPointsConstants.taskSubmissionsStorage}${attachmentsCategories!.videos![index].aAttachment!}',
                //                     // ),
                //                   ),
                //                 );
                //               },
                //               child: Container(
                //                 height: 200,
                //                 width: 132,
                //                 child: Stack(
                //                   children: [
                //                     MyThumbnailVideo(
                //                       margin: EdgeInsetsDirectional.only(end: 8),
                //                       index: index,
                //                       height: 200,
                //                       showVideoIcon: true,
                //                       thumbnail: submission
                //                                   .submissionAttachmentsCategories!
                //                                   .videos![index]
                //                                   .thumbnail !=
                //                               null
                //                           ? Image.network(
                //                               EndPointsConstants.thumbnailStorage +
                //                                   submission
                //                                       .submissionAttachmentsCategories!
                //                                       .videos![index]
                //                                       .thumbnail!,
                //                               fit: BoxFit.cover,
                //                             )
                //                           : Image.asset(
                //                               AssetsKeys.defaultVideoThumbnail,
                //                               fit: BoxFit.cover,
                //                             ),
                //                     ),
                //                     // // Video thumbnail image
                //                     // Positioned.fill(
                //                     //   child: attachmentsCategories!
                //                     //               .videos![index].thumbnail !=
                //                     //           null
                //                     //       ? Image.network(
                //                     //           EndPointsConstants.thumbnailStorage +
                //                     //               submission
                //                     //                   .submissionAttachmentsCategories!
                //                     //                   .videos![index]
                //                     //                   .thumbnail!,
                //                     //           fit: BoxFit.cover,
                //                     //         )
                //                     //       : Image.asset(
                //                     //           AssetsKeys.defaultVideoThumbnail,
                //                     //           fit: BoxFit.cover,
                //                     //         ),
                //                     // ),
                //                     // // Play icon overlay
                //                     // Center(
                //                     //   child: Icon(
                //                     //     Icons.play_circle_fill,
                //                     //     color: Colors.white,
                //                     //     size: 50.0,
                //                     //   ),
                //                     // ),
                //                     // Duration overlay
                //                     // Positioned(
                //                     //   bottom: 8.0,
                //                     //   right: 8.0,
                //                     //   child: Container(
                //                     //     padding: EdgeInsets.symmetric(
                //                     //         horizontal: 8.0, vertical: 4.0),
                //                     //     color: Colors.black.withOpacity(0.7),
                //                     //     child: Text(
                //                     //       'duration',
                //                     //       style: TextStyle(color: Colors.white),
                //                     //     ),
                //                     //   ),
                //                     // ),
                //                   ],
                //                 ),
                //               ),
                //             );
                //           },
                //           itemCount: submission
                //               .submissionAttachmentsCategories!.videos!.length,
                //         ),
                //       )
                //     : Container(),

                // const MyVerticalSpacer(),
              ],
            ),
          );
  }
}
