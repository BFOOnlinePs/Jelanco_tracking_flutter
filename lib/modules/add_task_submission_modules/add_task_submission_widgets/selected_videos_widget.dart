import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';

class SelectedVideosWidget extends StatelessWidget {
  final AddTaskSubmissionCubit addTaskSubmissionCubit;
  final TaskSubmissionModel? taskSubmissionModel;

  const SelectedVideosWidget(
      {super.key,
      required this.addTaskSubmissionCubit,
      required this.taskSubmissionModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          addTaskSubmissionCubit.pickedVideosList.isEmpty
              ? Container()
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MyVideo(
                          height: 200,
                          videoPlayerController:
                              addTaskSubmissionCubit.videoControllers[index],
                          index: index,
                          onTogglePlayPauseWithIndex:
                              addTaskSubmissionCubit.toggleVideoPlayPause,
                          showDeleteIcon: true,
                          onDeletePressed: () {
                            addTaskSubmissionCubit.deletedPickedVideoFromList(
                                index: index);
                          },
                          margin: const EdgeInsetsDirectional.only(end: 10));
                    },
                    itemCount: addTaskSubmissionCubit.pickedVideosList.length,
                  ),
                ),
          taskSubmissionModel == null ||
                  taskSubmissionModel!
                      .submissionAttachmentsCategories!.videos!.isEmpty ||
                  addTaskSubmissionCubit.oldVideoControllers.length <
                      taskSubmissionModel!
                          .submissionAttachmentsCategories!
                          .videos!
                          .length // to make sure that all the controllers initialized
              ? Container()
              : SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MyVideo(
                          // height: 200,

                          videoPlayerController:
                              addTaskSubmissionCubit.oldVideoControllers[index],
                          index: index,
                          onTogglePlayPauseWithIndex: (index) {
                            addTaskSubmissionCubit.toggleVideoPlayPause(index,
                                isOldVideos: true);
                          },
                          // addTaskSubmissionCubit
                          //     .toggleVideoPlayPause,

                          showDeleteIcon: true,
                          onDeletePressed: () {
                            addTaskSubmissionCubit.deletedPickedVideoFromList(
                                index: index,
                                taskSubmissionModel: taskSubmissionModel!);
                          },
                          margin: const EdgeInsetsDirectional.only(end: 10));
                    },
                    itemCount: taskSubmissionModel!
                        .submissionAttachmentsCategories!.videos!.length,
                  ),
                ),
        ],
      ),
    );
  }
}
