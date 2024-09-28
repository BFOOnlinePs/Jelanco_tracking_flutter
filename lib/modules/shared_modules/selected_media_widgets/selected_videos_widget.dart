import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:video_player/video_player.dart';

class SelectedVideosWidget extends StatelessWidget {
  final AttachmentsCategories? oldSubmissionAttachmentsCategories;
  final Function({
    required int index,
    AttachmentsCategories? attachmentsCategories,
  }) deletePickedVideoFromList;
  final List<XFile> pickedVideosList;
  final List<VideoPlayerController?> videosControllers;
  final List<VideoPlayerController?> oldVideoControllers;
  final Function(
    int index, {
    bool isOldVideos, // for edit
  }) toggleVideoPlayPause;

  const SelectedVideosWidget({
    super.key,
    this.oldSubmissionAttachmentsCategories,
    required this.deletePickedVideoFromList,
    required this.pickedVideosList,
    required this.videosControllers,
    required this.oldVideoControllers,
    required this.toggleVideoPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          pickedVideosList.isEmpty
              ? Container()
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MyVideo(
                          height: 200,
                          videoPlayerController: videosControllers[index],
                          index: index,
                          onTogglePlayPauseWithIndex: toggleVideoPlayPause,
                          showDeleteIcon: true,
                          onDeletePressed: () {
                            deletePickedVideoFromList(index: index);
                          },
                          margin: const EdgeInsetsDirectional.only(end: 10));
                    },
                    itemCount: pickedVideosList.length,
                  ),
                ),

          // the old picked videos list is empty (from network)

          oldSubmissionAttachmentsCategories == null ||

                  // taskSubmissionModel == null ||
                  oldSubmissionAttachmentsCategories!.videos!.isEmpty ||
                  oldVideoControllers.length <
                      oldSubmissionAttachmentsCategories!.videos!
                          .length // to make sure that all the controllers initialized
              // ? Container(child: Text('لا توجد فيديوات او مش معمول initialize'),)
              ? Container()
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MyVideo(
                          // height: 200,

                          videoPlayerController: oldVideoControllers[index],
                          index: index,
                          onTogglePlayPauseWithIndex: (index) {
                            toggleVideoPlayPause(index, isOldVideos: true);
                          },
                          showDeleteIcon: true,
                          onDeletePressed: () {
                            deletePickedVideoFromList(
                              index: index,
                              attachmentsCategories:
                                  oldSubmissionAttachmentsCategories,
                            );
                          },
                          margin: const EdgeInsetsDirectional.only(end: 10));
                    },
                    itemCount:
                        oldSubmissionAttachmentsCategories!.videos!.length,
                  ),
                ),
        ],
      ),
    );
  }
}
