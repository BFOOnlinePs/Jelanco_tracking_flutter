import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';
import 'package:jelanco_tracking_system/widgets/my_images/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';
import 'package:video_player/video_player.dart';

class AddTaskSubmissionScreen extends StatelessWidget {
  AddTaskSubmissionScreen({super.key});

  late AddTaskSubmissionCubit addTaskSubmissionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskSubmissionCubit(),
      child: BlocConsumer<AddTaskSubmissionCubit, AddTaskSubmissionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          addTaskSubmissionCubit = AddTaskSubmissionCubit.get(context);
          return Scaffold(
            appBar: MyAppBar(title: 'add_task_submission_title'.tr()),
            body: Stack(
              children: [
                MyScreen(
                  child: Form(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MyTextFormField(
                                  titleText:
                                  'add_task_submission_content_field'.tr(),
                                  labelText:
                                  'add_task_submission_content_field_label'
                                      .tr(),
                                  // controller: addTaskCubit.contentController,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  isFieldRequired: true,
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'add_task_submission_content_required_validation'
                                          .tr();
                                    }
                                  },
                                ),
                                // MyTextButton(
                                //     onPressed: () {
                                //       addTaskSubmissionCubit.requestPermission(
                                //           context: context,
                                //           permissionType:
                                //               PermissionType.storage,
                                //           functionWhenGranted:
                                //               addTaskSubmissionCubit
                                //                   .pickMultipleVideosFromGallery);
                                //     },
                                //     child: Text('صور / فيديوهات')),
                                // addTaskSubmissionCubit
                                //         .thePickedVideosList.isEmpty
                                //     ? Text('قم بإختيار فيديوهات')
                                //     : Container(
                                //         height: 200,
                                //         child: ListView.builder(
                                //           scrollDirection: Axis.horizontal,
                                //           shrinkWrap: true,
                                //           itemBuilder: (context, index) =>
                                //               MyImage(
                                //                   height: 100,
                                //                   showDeleteIcon: true,
                                //                   onDeletePressed: () {
                                //                     addTaskSubmissionCubit
                                //                         .deletedPickedVideoFromList(
                                //                             index: index);
                                //                   },
                                //                   child: Image.file(
                                //                     File(addTaskSubmissionCubit
                                //                         .thePickedVideosList[
                                //                             index]
                                //                         .path),
                                //                   ),
                                //                   margin: EdgeInsetsDirectional
                                //                       .only(end: 10)),
                                //           itemCount: addTaskSubmissionCubit
                                //               .thePickedVideosList.length,
                                //         ),
                                //       ),
                                MyTextButton(
                                    onPressed: () {
                                      addTaskSubmissionCubit.requestPermission(
                                          context: context,
                                          permissionType:
                                          PermissionType.storage,
                                          functionWhenGranted:
                                          addTaskSubmissionCubit
                                              .pickMultipleImagesFromGallery);
                                    },
                                    child: Text('صور')),
                                addTaskSubmissionCubit
                                    .thePickedImagesList.isEmpty
                                    ? Text('قم بإختيار الصور')
                                    : Container(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        MyImage(
                                            height: 100,
                                            showDeleteIcon: true,
                                            onDeletePressed: () {
                                              addTaskSubmissionCubit
                                                  .deletedPickedImageFromList(
                                                  index: index);
                                            },
                                            child: Image.file(
                                              File(addTaskSubmissionCubit
                                                  .thePickedImagesList[
                                              index]
                                                  .path),
                                            ),
                                            margin: EdgeInsetsDirectional
                                                .only(end: 10)),
                                    itemCount: addTaskSubmissionCubit
                                        .thePickedImagesList.length,
                                  ),
                                ),

                                MyTextButton(
                                    onPressed: () {
                                      addTaskSubmissionCubit.requestPermission(
                                          context: context,
                                          permissionType:
                                          PermissionType.storage,
                                          functionWhenGranted:
                                          addTaskSubmissionCubit
                                              .pickMultipleVideosFromGallery);
                                    },
                                    child: Text('فيديوهات')),
                                addTaskSubmissionCubit.pickedVideosList.isEmpty
                                    ? Text('قم بإختيار الفيديوهات')
                                    : Container(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          // if (addTaskSubmissionCubit
                                          //     .videoControllers[index]?.value
                                          //     .isInitialized == true)
                                            Container(
                                              height: 100,
                                              child: AspectRatio(
                                                aspectRatio: addTaskSubmissionCubit
                                                    .videoControllers[index]!
                                                    .value.aspectRatio,
                                                child: VideoPlayer(
                                                    addTaskSubmissionCubit
                                                        .videoControllers[index]!),
                                              ),
                                            ),
                                          if (addTaskSubmissionCubit
                                              .videoControllers[index]?.value
                                              .isInitialized == true)
                                            Container(
                                              width: 100,
                                              child: VideoProgressIndicator(
                                                  addTaskSubmissionCubit
                                                      .videoControllers[index]!,
                                                  allowScrubbing: true),
                                            ),
                                          // IconButton(
                                          //   icon: Icon(addTaskSubmissionCubit
                                          //       .videoControllers[index]!.value
                                          //       .isPlaying ? Icons.pause : Icons
                                          //       .play_arrow),
                                          //   onPressed: () {
                                          //     addTaskSubmissionCubit
                                          //         .toggleVideoPlayPause(index);
                                          //   },
                                          // ),
                                        ],
                                      );
                                    },
                                    // MyImage(
                                    //     height: 100,
                                    //     showDeleteIcon: true,
                                    //     onDeletePressed: () {
                                    //       addTaskSubmissionCubit
                                    //           .deletedPickedVideoFromList(
                                    //               index: index);
                                    //     },
                                    //     child: Image.file(
                                    //       File(addTaskSubmissionCubit
                                    //           .pickedVideosList[index]
                                    //           .path),
                                    //     ),
                                    //     margin: EdgeInsetsDirectional
                                    //         .only(end: 10)),
                                    itemCount: addTaskSubmissionCubit
                                    .pickedVideosList.length,
                                  ),
                                ),

                                MyTextButton(
                                    onPressed: () {
                                      addTaskSubmissionCubit.requestPermission(
                                          context: context,
                                          permissionType:
                                          PermissionType.storage,
                                          functionWhenGranted:
                                          addTaskSubmissionCubit
                                              .pickReportFile);
                                    },
                                    child: Text('ملفات')),
                                addTaskSubmissionCubit.pickedFilesList.isEmpty
                                    ? Text('قم بإختيار الملفات')
                                    : Container(
                                  // height: 200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String fileName =
                                          addTaskSubmissionCubit
                                              .pickedFilesList[index].path
                                              .split('/')
                                              .last;
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                          BorderRadius.circular(8),
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
                                            onPressed: () =>
                                                addTaskSubmissionCubit
                                                    .deletedPickedFileFromList(
                                                    index: index),
                                          ),
                                          title: Text(fileName),
                                          // subtitle: Text(pickedFiles[index].path),
                                        ),
                                      );
                                    },
                                    //     ListTile(
                                    //   leading: IconButton(
                                    //     icon: Icon(Icons.close),
                                    //     onPressed: () =>
                                    //         addTaskSubmissionCubit
                                    //             .deletedPickedfileFromList(
                                    //                 index: index),
                                    //   ),
                                    //   title: Text(addTaskSubmissionCubit
                                    //       .pickedFilesList[index].path
                                    //       .split('/')
                                    //       .last),
                                    // ),
                                    itemCount: addTaskSubmissionCubit
                                        .pickedFilesList.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          onPressed: () {},
                          child: Text('add_task_submission_button_submit'.tr()),
                          isWidthFull: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
