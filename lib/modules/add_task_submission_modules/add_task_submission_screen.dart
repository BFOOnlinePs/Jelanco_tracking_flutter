import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_widgets/camera_options_popup_menu.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_widgets/selected_attachments_widget.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_widgets/selected_images_widget.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_widgets/selected_videos_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
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
                            controller: addTaskSubmissionCubit.scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  maxLines:
                                      addTaskSubmissionCubit.contentMaxLines,
                                  onChanged: (text) {
                                    addTaskSubmissionCubit
                                        .changeContentMaxLines(text: text);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'add_task_submission_content_required_validation'
                                          .tr();
                                    }
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 14, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //from camera
                                      // PopupMenuButton<String>(
                                      //   onSelected: (String value) {
                                      //     // if (value == 'image') {
                                      //     //   _pickMedia(context, isVideo: false);
                                      //     // } else if (value == 'video') {
                                      //     //   _pickMedia(context, isVideo: true);
                                      //     // }
                                      //   },
                                      //
                                      //   itemBuilder: (BuildContext context) =>
                                      //       <PopupMenuEntry<String>>[
                                      //     PopupMenuItem<String>(
                                      //       value: 'image',
                                      //       child: ListTile(
                                      //         leading: Icon(Icons.image),
                                      //         title: Text('Pick Image'),
                                      //       ),
                                      //     ),
                                      //     PopupMenuItem<String>(
                                      //       value: 'video',
                                      //       child: ListTile(
                                      //         leading: Icon(Icons.videocam),
                                      //         title: Text('Pick Video'),
                                      //       ),
                                      //     ),
                                      //   ],
                                      //   child: MediaOptionWidget(
                                      //     icon: Icons.camera_alt,
                                      //     label: 'كاميرا',
                                      //     color: Colors.blue,
                                      //     onTap: () {
                                      //       showPopupMenu(context);
                                      //
                                      //       // addTaskSubmissionCubit.requestPermission(
                                      //       //     context: context,
                                      //       //     permissionType:
                                      //       //         PermissionType.camera,
                                      //       //     functionWhenGranted:
                                      //       //         addTaskSubmissionCubit
                                      //       //             .pickImageFromCamera);
                                      //     },
                                      //   ),
                                      // ),

                                      TaskOptionsWidget(
                                          child: MediaOptionWidget(
                                            icon: Icons.camera_alt,
                                            label: 'كاميرا',
                                            color: Colors.blue,
                                            onTap: null,
                                          ),
                                          menuItems: [
                                            MenuItemModel(
                                              icon: Icons.image,
                                              iconColor: Colors.green,
                                              label: 'إلتقاط صورة',
                                              onTap: () {
                                                addTaskSubmissionCubit
                                                    .requestPermission(
                                                        context: context,
                                                        permissionType:
                                                            PermissionType
                                                                .camera,
                                                        functionWhenGranted:
                                                            addTaskSubmissionCubit
                                                                .pickMediaFromCamera);
                                              },
                                            ),
                                            MenuItemModel(
                                              icon: Icons.video_camera_back,
                                              label: 'إلتقاط فيديو',
                                              iconColor: Colors.red,
                                              onTap: () {
                                                addTaskSubmissionCubit
                                                    .requestPermission(
                                                        context: context,
                                                        permissionType:
                                                            PermissionType
                                                                .camera,
                                                        functionWhenGranted: () =>
                                                            addTaskSubmissionCubit
                                                                .pickMediaFromCamera(
                                                                    isImage:
                                                                        false));
                                              },
                                            ),
                                          ]),

                                      // MediaOptionWidget(
                                      //   icon: Icons.camera_alt,
                                      //   label: 'كاميرا',
                                      //   color: Colors.blue,
                                      //   onTap: () {
                                      //     TaskOptionsWidget(menuItems: [
                                      //       MenuItemModel(icon: Icons.add, label: 'label', onTap: (){})
                                      //     ]);
                                      //
                                      //     // addTaskSubmissionCubit.requestPermission(
                                      //     //     context: context,
                                      //     //     permissionType:
                                      //     //         PermissionType.camera,
                                      //     //     functionWhenGranted:
                                      //     //         addTaskSubmissionCubit
                                      //     //             .pickImageFromCamera);
                                      //   },
                                      // ),

                                      Container(
                                          width: 0.2,
                                          height: 26,
                                          color: Colors.grey),

                                      MediaOptionWidget(
                                        icon: Icons.image,
                                        label: 'صورة',
                                        color: Colors.green,
                                        onTap: () {
                                          addTaskSubmissionCubit.requestPermission(
                                              context: context,
                                              permissionType:
                                                  PermissionType.storage,
                                              functionWhenGranted:
                                                  addTaskSubmissionCubit
                                                      .pickMultipleImagesFromGallery);
                                        },
                                      ),
                                      Container(
                                          width: 0.2,
                                          height: 26,
                                          color: Colors.grey),
                                      MediaOptionWidget(
                                        icon: Icons.video_camera_back,
                                        label: 'فيديو',
                                        color: Colors.red,
                                        onTap: () {
                                          addTaskSubmissionCubit.requestPermission(
                                              context: context,
                                              permissionType:
                                                  PermissionType.storage,
                                              functionWhenGranted:
                                                  addTaskSubmissionCubit
                                                      .pickVideoFromGallery);
                                        },
                                      ),
                                      Container(
                                          width: 0.2,
                                          height: 26,
                                          color: Colors.grey),
                                      MediaOptionWidget(
                                        icon: Icons.attach_file,
                                        label: 'ملف',
                                        color: Colors.blue,
                                        onTap: () {
                                          addTaskSubmissionCubit
                                              .requestPermission(
                                                  context: context,
                                                  permissionType:
                                                      PermissionType.storage,
                                                  functionWhenGranted:
                                                      addTaskSubmissionCubit
                                                          .pickReportFile);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SelectedImagesWidget(
                                    addTaskSubmissionCubit:
                                        addTaskSubmissionCubit,
                                    taskSubmissionModel: taskSubmissionModel),
                                SizedBox(
                                  height: 14,
                                ),
                                SelectedVideosWidget(
                                    addTaskSubmissionCubit:
                                        addTaskSubmissionCubit,
                                    taskSubmissionModel: taskSubmissionModel),
                                SelectedAttachmentsWidget(
                                    addTaskSubmissionCubit:
                                        addTaskSubmissionCubit,
                                    taskSubmissionModel: taskSubmissionModel),
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
                            } else {
                              print('not valid');
                              ScrollUtils.scrollPosition(
                                  scrollController:
                                      addTaskSubmissionCubit.scrollController);
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
