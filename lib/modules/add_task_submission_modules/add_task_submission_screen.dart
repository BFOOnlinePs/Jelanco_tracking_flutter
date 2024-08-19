import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_screen.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

// to add submission, regardless if it is the original submission or edit submission / new version or submission without task
class AddTaskSubmissionScreen extends StatelessWidget {
  final int taskId;
  final TaskSubmissionModel? taskSubmissionModel; // for edit
  final bool isEdit; // for edit

  AddTaskSubmissionScreen({
    super.key,
    required this.taskId,
    this.taskSubmissionModel,
    this.isEdit = false,
  });

  late AddTaskSubmissionCubit addTaskSubmissionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskSubmissionCubit()
        ..getOldData(isEdit: isEdit, taskSubmissionModel: taskSubmissionModel),
      child: BlocConsumer<AddTaskSubmissionCubit, AddTaskSubmissionStates>(
        listener: (context, state) {
          print('state is $state');
          if (state is AddTaskSubmissionInitialState) {
            print('this is the initial state');
          }
          if (state is AddTaskSubmissionSuccessState) {
            if (state.addTaskSubmissionModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.addTaskSubmissionModel.message,
              );
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.addTaskSubmissionModel.message,
              );
            }
          } else if (state is AddTaskSubmissionFileSelectErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          addTaskSubmissionCubit = AddTaskSubmissionCubit.get(context);
          return Scaffold(
            appBar: MyAppBar(title: 'add_task_submission_title'.tr()),
            body: Stack(
              children: [
                MyScreen(
                  child: Form(
                    key: addTaskSubmissionCubit.addTaskSubmissionFormKey,
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
                                  controller:
                                      addTaskSubmissionCubit.contentController,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  isFieldRequired: true,
                                  maxLines: null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'add_task_submission_content_required_validation'
                                          .tr();
                                    }
                                  },
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildMediaOption(
                                      icon: Icons.image,
                                      label: 'صور',
                                      color: Colors.green,
                                      onTap: () {},
                                    ),
                                    Container(
                                        width: 0.2,
                                        height: 26,
                                        color: Colors.grey),
                                    buildMediaOption(
                                      icon: Icons.video_camera_back,
                                      label: 'فيديوهات',
                                      color: Colors.red,
                                      onTap: () {},
                                    ),
                                    Container(
                                        width: 0.2,
                                        height: 26,
                                        color: Colors.grey),
                                    buildMediaOption(
                                      icon: Icons.attach_file,
                                      label: 'ملفات',
                                      color: Colors.blue,
                                      onTap: () {},
                                    ),
                                  ],
                                ),

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

                                addTaskSubmissionCubit.pickedImagesList
                                        .isEmpty // new picked (from file)

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
                                                        .pickedImagesList[index]
                                                        .path),
                                                  ),
                                                  margin: EdgeInsetsDirectional
                                                      .only(end: 10)),
                                          itemCount: addTaskSubmissionCubit
                                              .pickedImagesList.length,
                                        ),
                                      ),

                                // the old picked images list is empty (from network)
                                taskSubmissionModel == null ||
                                        taskSubmissionModel!
                                            .submissionAttachmentsCategories!
                                            .images!
                                            .isEmpty
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
                                                            index: index,
                                                            taskSubmissionModel:
                                                                taskSubmissionModel!);
                                                  },
                                                  margin: EdgeInsetsDirectional
                                                      .only(end: 10),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      '${EndPointsConstants.taskSubmissionsStorage}${taskSubmissionModel!.submissionAttachmentsCategories!.images![index].aAttachment}',
                                                    ),
                                                  )),
                                          itemCount: taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .images!
                                              .length,
                                        ),
                                      ),

                                MyTextButton(
                                  onPressed: () {
                                    addTaskSubmissionCubit.requestPermission(
                                        context: context,
                                        permissionType: PermissionType.storage,
                                        functionWhenGranted:
                                            addTaskSubmissionCubit
                                                .pickMultipleVideosFromGallery);
                                  },
                                  child: Text('فيديوهات'),
                                ),
                                addTaskSubmissionCubit.pickedVideosList.isEmpty
                                    ? Text('قم بإختيار الفيديوهات')
                                    : Container(
                                        height: 280,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return MyVideo(
                                                // height: 200,
                                                videoPlayerController:
                                                    addTaskSubmissionCubit
                                                            .videoControllers[
                                                        index],
                                                index: index,
                                                onTogglePlayPauseWithIndex:
                                                    addTaskSubmissionCubit
                                                        .toggleVideoPlayPause,
                                                showDeleteIcon: true,
                                                onDeletePressed: () {
                                                  addTaskSubmissionCubit
                                                      .deletedPickedVideoFromList(
                                                          index: index);
                                                },
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        end: 10));
                                          },
                                          itemCount: addTaskSubmissionCubit
                                              .pickedVideosList.length,
                                        ),
                                      ),

                                taskSubmissionModel == null ||
                                        taskSubmissionModel!
                                            .submissionAttachmentsCategories!
                                            .videos!
                                            .isEmpty ||
                                        addTaskSubmissionCubit
                                                .oldVideoControllers.length <
                                            taskSubmissionModel!
                                                .submissionAttachmentsCategories!
                                                .videos!
                                                .length // to make sure that all the controllers initialized
                                    ? Text('قم بإختيار الفيديوهات')
                                    : Container(
                                        height: 280,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return MyVideo(
                                                // height: 200,

                                                videoPlayerController:
                                                    addTaskSubmissionCubit
                                                            .oldVideoControllers[
                                                        index],
                                                index: index,
                                                onTogglePlayPauseWithIndex:
                                                    (index) {
                                                  addTaskSubmissionCubit
                                                      .toggleVideoPlayPause(
                                                          index,
                                                          isOldVideos: true);
                                                },
                                                // addTaskSubmissionCubit
                                                //     .toggleVideoPlayPause,

                                                showDeleteIcon: true,
                                                onDeletePressed: () {
                                                  addTaskSubmissionCubit
                                                      .deletedPickedVideoFromList(
                                                          index: index,
                                                          taskSubmissionModel:
                                                              taskSubmissionModel!);
                                                },
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        end: 10));
                                          },
                                          itemCount: taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .videos!
                                              .length,
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
                                          itemCount: addTaskSubmissionCubit
                                              .pickedFilesList.length,
                                        ),
                                      ),

                                taskSubmissionModel == null ||
                                        taskSubmissionModel!
                                            .submissionAttachmentsCategories!
                                            .files!
                                            .isEmpty
                                    ? Text('قم بإختيار الملفات')
                                    : Container(
                                        // height: 200,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            String? fileName = taskSubmissionModel!
                                                .submissionAttachmentsCategories!
                                                .files![index]
                                                .aAttachment;
                                            // String fileName =
                                            //     addTaskSubmissionCubit
                                            //         .pickedFilesList[index].path
                                            //         .split('/')
                                            //         .last;
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
                                                      // .......................................
                                                      addTaskSubmissionCubit
                                                          .deletedPickedFileFromList(
                                                              index: index,
                                                              taskSubmissionModel:
                                                                  taskSubmissionModel),
                                                ),
                                                title: Text(
                                                    fileName ?? 'file name'),
                                                // subtitle: Text(pickedFiles[index].path),
                                              ),
                                            );
                                          },
                                          itemCount: taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .files!
                                              .length,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          onPressed: () {
                            if (addTaskSubmissionCubit
                                .addTaskSubmissionFormKey.currentState!
                                .validate()) {
                              addTaskSubmissionCubit
                                  .isAddTaskSubmissionLoading = true;
                              addTaskSubmissionCubit.emitLoading();
                              addTaskSubmissionCubit
                                  .requestPermission(
                                context: context,
                                permissionType: PermissionType.location,
                                functionWhenGranted:
                                    addTaskSubmissionCubit.getCurrentLocation,
                              )
                                  .then((value) {
                                print('add task .then');
                                addTaskSubmissionCubit.addNewTaskSubmission(
                                  taskId: taskId,
                                  isEdit: isEdit,
                                  taskSubmissionId:
                                      taskSubmissionModel?.tsId ?? -1,
                                  oldAttachments: isEdit
                                      ? [
                                          ...taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .images!
                                              .map((e) => e.aAttachment!),
                                          ...taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .videos!
                                              .map((e) => e.aAttachment!),
                                          ...taskSubmissionModel!
                                              .submissionAttachmentsCategories!
                                              .files!
                                              .map((e) => e.aAttachment!),
                                        ]
                                      : [],
                                );
                              }).catchError((error) {
                                print('error with location !!');
                              });
                            }
                          },
                          // child: Text('add_task_submission_button_submit'.tr()),
                          isWidthFull: true,
                          buttonText: 'add_task_submission_button_submit'.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                // addTaskSubmissionCubit.state is AddTaskSubmissionLoadingState
                addTaskSubmissionCubit.isAddTaskSubmissionLoading
                    ? const LoaderWithDisable()
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
