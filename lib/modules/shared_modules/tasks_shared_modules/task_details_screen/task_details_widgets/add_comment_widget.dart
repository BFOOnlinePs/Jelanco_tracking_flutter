import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class AddCommentWidget extends StatelessWidget {
  final int taskId;
  final int taskSubmissionId;

  const AddCommentWidget({
    super.key,
    required this.taskId,
    required this.taskSubmissionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailsCubit, TaskDetailsStates>(
      listener: (context, state) {
        if (state is AddCommentSuccessState) {
          SnackbarHelper.showSnackbar(
            context: context,
            snackBarStates: state.addTaskSubmissionCommentModel.status == true
                ? SnackBarStates.success
                : SnackBarStates.error,
            message: state.addTaskSubmissionCommentModel.message!,
          );
          Navigator.pop(context);
        }
        if (state is AddCommentErrorState) {
          SnackbarHelper.showSnackbar(
            context: context,
            snackBarStates: SnackBarStates.error,
            message: state.error,
          );
        }
        if (state is AddCommentLoadingState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        TaskDetailsCubit taskDetailsCubit = TaskDetailsCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.withOpacity(0.12),
                  // backgroundImage:
                  //     NetworkImage('https://example.com/profile_pic.jpg'),
                ),
                SizedBox(width: 10),

                // Comment Input Field
                Expanded(
                  child: TextFormField(
                    focusNode: taskDetailsCubit.focusNode,
                    maxLines: 4,
                    controller: taskDetailsCubit.commentController,
                    onChanged: (value) {
                      taskDetailsCubit.changeCommentText(text: value);
                    },
                    decoration: InputDecoration(
                      hintText: 'أكتب تعليق ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.12),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                // SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  taskDetailsCubit.pickedImagesList.isEmpty
                      ? Container()
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => MyImage(
                                height: 100,
                                showDeleteIcon: true,
                                onDeletePressed: () {
                                  taskDetailsCubit.deletedPickedImageFromList(
                                      index: index);
                                },
                                child: Image.file(
                                  File(taskDetailsCubit
                                      .pickedImagesList[index].path),
                                ),
                                margin: EdgeInsetsDirectional.only(end: 10)),
                            itemCount: taskDetailsCubit.pickedImagesList.length,
                          ),
                        ),
                  taskDetailsCubit.pickedVideosList.isEmpty
                      ? Container()
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return MyVideo(
                                height: 150,
                                videoPlayerController:
                                    taskDetailsCubit.videoControllers[index],
                                index: index,
                                showDeleteIcon: true,
                                onDeletePressed: () {
                                  taskDetailsCubit.deletedPickedVideoFromList(
                                      index: index);
                                },
                                margin: EdgeInsetsDirectional.only(end: 10),
                                showTogglePlayPause: false,
                                showVideoIcon: true,
                              );
                            },
                            itemCount: taskDetailsCubit.pickedVideosList.length,
                          ),
                        ),
                ],
              ),
            ),

            taskDetailsCubit.pickedFilesList.isEmpty
                ? Container()
                : Container(
                    // height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String fileName = taskDetailsCubit
                            .pickedFilesList[index].path
                            .split('/')
                            .last;
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => taskDetailsCubit
                                  .deletedPickedFileFromList(index: index),
                            ),
                            title: Text(
                              fileName,
                              style: TextStyle(fontSize: 14),
                            ),
                            // subtitle: Text(pickedFiles[index].path),
                          ),
                        );
                      },
                      itemCount: taskDetailsCubit.pickedFilesList.length,
                    ),
                  ),

            // Media Options (File, Image, Video)
            Row(
              children: [
                MediaOptionButton(
                  icon: Icons.image_outlined,
                  onPressed: () {
                    taskDetailsCubit.requestPermission(
                        context: context,
                        permissionType: PermissionType.storage,
                        functionWhenGranted:
                            taskDetailsCubit.pickMultipleImagesFromGallery);
                  },
                ),
                MediaOptionButton(
                  icon: Icons.video_library_outlined,
                  onPressed: () {
                    taskDetailsCubit.requestPermission(
                        context: context,
                        permissionType: PermissionType.storage,
                        functionWhenGranted:
                            taskDetailsCubit.pickMultipleVideosFromGallery);
                  },
                ),
                MediaOptionButton(
                  icon: Icons.insert_drive_file_outlined,
                  onPressed: () {
                    taskDetailsCubit.requestPermission(
                        context: context,
                        permissionType: PermissionType.storage,
                        functionWhenGranted: taskDetailsCubit.pickReportFile);
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.send,
                      color: taskDetailsCubit.commentController.text.isEmpty
                          ? Colors.grey
                          : ColorsConstants.primaryColor),
                  onPressed: taskDetailsCubit.commentController.text.isEmpty
                      ? null
                      : () {
                          taskDetailsCubit.addComment(
                            taskId: taskId,
                            taskSubmissionId: taskSubmissionId,
                            parentId: -1,
                            commentContent:
                                taskDetailsCubit.commentController.text,
                          );
                        },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class MediaOptionButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  MediaOptionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: ColorsConstants.primaryColor),
          SizedBox(width: 10),
          // Text(
          //   label,
          //   style: TextStyle(color: ColorsConstants.primaryColor),
          // ),
        ],
      ),
    );
  }
}
