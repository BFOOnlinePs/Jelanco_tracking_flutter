import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_cubit/add_comment_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/add_comment_modules/add_comment_cubit/add_comment_states.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class AddCommentWidget extends StatelessWidget {
  final int taskId;
  final int taskSubmissionId;

  // final CommentService? commentService;

  // call the function when pop
  final Function() whenCommentAdded; // call get data of the previous screen

  late AddCommentCubit addCommentCubit;

  AddCommentWidget({
    super.key,
    required this.taskId,
    required this.taskSubmissionId,
    required this.whenCommentAdded,
    // required this.commentService
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCommentCubit(),
      child: BlocConsumer<AddCommentCubit, AddCommentStates>(
        listener: (context, state) {
          if (state is AddCommentSuccessState) {
            // SnackbarHelper.showSnackbar(
            //   context: context,
            //   snackBarStates: state.addTaskSubmissionCommentModel.status == true
            //       ? SnackBarStates.success
            //       : SnackBarStates.error,
            //   message: state.addTaskSubmissionCommentModel.message!,
            // );
            whenCommentAdded();
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
            addCommentCubit.focusNode.unfocus();
          }
        },
        builder: (context, state) {
          addCommentCubit = AddCommentCubit.get(context);
          return IgnorePointer(
            ignoring: state is AddCommentLoadingState ? true : false,
            child: SingleChildScrollView(
              // physics: AlwaysScrollableScrollPhysics(s),
              child: Column(
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
                          focusNode: addCommentCubit.focusNode,
                          maxLines: 4,
                          controller: addCommentCubit.commentController,
                          onChanged: (value) {
                            addCommentCubit.changeCommentText(text: value);
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  state is AddCommentLoadingState
                      ? Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: LinearProgressIndicator(),
                        )
                      : Container(),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        addCommentCubit.pickedImagesList.isEmpty
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
                                        addCommentCubit
                                            .deletedPickedImageFromList(
                                                index: index);
                                      },
                                      child: Image.file(
                                        File(addCommentCubit
                                            .pickedImagesList[index].path),
                                      ),
                                      margin:
                                          EdgeInsetsDirectional.only(end: 10)),
                                  itemCount:
                                      addCommentCubit.pickedImagesList.length,
                                ),
                              ),
                        addCommentCubit.pickedVideosList.isEmpty
                            ? Container()
                            : Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return MyVideo(
                                      height: 150,
                                      videoPlayerController: addCommentCubit
                                          .videoControllers[index],
                                      index: index,
                                      showDeleteIcon: true,
                                      onDeletePressed: () {
                                        addCommentCubit
                                            .deletedPickedVideoFromList(
                                                index: index);
                                      },
                                      margin:
                                          EdgeInsetsDirectional.only(end: 10),
                                      showTogglePlayPause: false,
                                      showVideoIcon: true,
                                    );
                                  },
                                  itemCount:
                                      addCommentCubit.pickedVideosList.length,
                                ),
                              ),
                      ],
                    ),
                  ),

                  addCommentCubit.pickedFilesList.isEmpty
                      ? Container()
                      : Container(
                          height: addCommentCubit.pickedFilesList.length > 3
                              ? 200
                              : null,
                          child: ListView.builder(
                            shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              String fileName = addCommentCubit
                                  .pickedFilesList[index].path
                                  .split('/')
                                  .last;
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
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
                                    onPressed: () => addCommentCubit
                                        .deletedPickedFileFromList(
                                            index: index),
                                  ),
                                  title: Text(
                                    fileName,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  // subtitle: Text(pickedFiles[index].path),
                                ),
                              );
                            },
                            itemCount: addCommentCubit.pickedFilesList.length,
                          ),
                        ),

                  // Media Options (File, Image, Video)
                  Row(
                    children: [
                      TaskOptionsWidget(
                        child: MediaOptionButton(
                          icon: Icons.camera_alt_outlined,
                          onPressed: null,
                        ),
                        menuItems: [
                          MenuItemModel(
                            icon: Icons.image_outlined,
                            iconColor: ColorsConstants.primaryColor,
                            label: 'إلتقاط صورة',
                            onTap: () {
                              addCommentCubit.requestPermission(
                                  context: context,
                                  permissionType: PermissionType.camera,
                                  functionWhenGranted:
                                      addCommentCubit.pickMediaFromCamera);
                            },
                          ),
                          MenuItemModel(
                            icon: Icons.video_camera_back_outlined,
                            label: 'إلتقاط فيديو',
                            iconColor: ColorsConstants.primaryColor,
                            onTap: () { 
                              addCommentCubit.requestPermission(
                                  context: context,
                                  permissionType: PermissionType.camera,
                                  functionWhenGranted: () => addCommentCubit
                                      .pickMediaFromCamera(isImage: false));
                            },
                          ),
                        ],
                      ),
                      MediaOptionButton(
                        icon: Icons.image_outlined,
                        onPressed: () {
                          addCommentCubit.requestPermission(
                              context: context,
                              permissionType: PermissionType.storage,
                              functionWhenGranted: addCommentCubit
                                  .pickMultipleImagesFromGallery);
                        },
                      ),
                      MediaOptionButton(
                        icon: Icons.video_library_outlined,
                        onPressed: () {
                          addCommentCubit.requestPermission(
                              context: context,
                              permissionType: PermissionType.storage,
                              functionWhenGranted: addCommentCubit
                                  .pickMultipleVideosFromGallery);
                        },
                      ),
                      MediaOptionButton(
                        icon: Icons.insert_drive_file_outlined,
                        onPressed: () {
                          addCommentCubit.requestPermission(
                              context: context,
                              permissionType: PermissionType.storage,
                              functionWhenGranted:
                                  addCommentCubit.pickReportFile);
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.send,
                            color:
                                addCommentCubit.commentController.text.isEmpty
                                    ? Colors.grey
                                    : ColorsConstants.primaryColor),
                        onPressed: addCommentCubit
                                .commentController.text.isEmpty
                            ? null
                            : () {
                                addCommentCubit.addComment(
                                  // commentService: commentService,

                                  taskId: taskId,
                                  taskSubmissionId: taskSubmissionId,
                                  parentId: -1,
                                  commentContent:
                                      addCommentCubit.commentController.text,
                                );
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaOptionButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

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
