import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_attachments_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_images_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_videos_widget.dart';

import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_horizontal_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

// to add submission (in 3 states)
// regardless if it is the original submission or edit submission / new version or submission without task
class AddTaskSubmissionScreen extends StatelessWidget {
  final int taskId; // -1 when add submission without task
  final TaskSubmissionModel? taskSubmissionModel; // for edit
  final bool isEdit; // for edit

  final Function(TaskSubmissionModel)?
      // final Function(TaskSubmissionModel)?
      getDataCallback; // to get the data after add new submission

  AddTaskSubmissionScreen({
    super.key,
    required this.taskId,
    this.taskSubmissionModel,
    this.isEdit = false,
    required this.getDataCallback,
  });

  late AddTaskSubmissionCubit addTaskSubmissionCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskSubmissionCubit()
        ..getTaskCategories(
          loadingState: CategoriesLoadingState(),
          successState: CategoriesSuccessState(),
          errorState: (error) => CategoriesErrorState(error: error),
        ).then((_) {
          addTaskSubmissionCubit.getOldData(
            isEdit: isEdit,
            taskSubmissionModel: taskSubmissionModel,
          );
        }),
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

              // Trigger the callback when popping
              if (getDataCallback != null) {
                getDataCallback!(state.addTaskSubmissionModel.taskSubmission!);
              }
              Navigator.pop(context);
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
            appBar: MyAppBar(
              title: isEdit
                  ? 'تعديل التسليم'
                  : taskId == -1
                      ? 'إضافة تسليم جديد'
                      : 'تسليم المهمة المكلف بها',
            ),
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
                                    return null;
                                  },
                                ),
                                // const MyVerticalSpacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyTextFormField(
                                        titleText:
                                            'add_task_start_time_field'.tr(),
                                        labelText:
                                            'add_task_start_time_field_label'
                                                .tr(),
                                        readOnly: true,
                                        onTap: () => addTaskSubmissionCubit
                                            .selectDateTime(context, true),
                                        // validator: (value) =>
                                        //     addTaskCubit.plannedStartTime == null
                                        //         ? 'Select a start time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: addTaskSubmissionCubit
                                                        .startTime !=
                                                    null
                                                ? MyDateUtils.formatDateTime(
                                                    addTaskSubmissionCubit
                                                        .startTime!)
                                                : ''),
                                        style: TextStyle(
                                          fontSize:
                                              SharedSize.textFiledTitleSize,
                                        ),
                                      ),
                                    ),
                                    const MyHorizontalSpacer(),
                                    Expanded(
                                      child: MyTextFormField(
                                        titleText:
                                            'add_task_end_time_field'.tr(),
                                        labelText:
                                            'add_task_end_time_field_label'
                                                .tr(),
                                        readOnly: true,
                                        onTap: () => addTaskSubmissionCubit
                                            .selectDateTime(context, false),
                                        // validator: (value) =>
                                        //     addTaskSubmissionCubit.plannedEndTime == null
                                        //         ? 'Select an end time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: addTaskSubmissionCubit
                                                        .endTime !=
                                                    null
                                                ? MyDateUtils.formatDateTime(
                                                    addTaskSubmissionCubit
                                                        .endTime!)
                                                : ''),
                                        style: TextStyle(
                                          fontSize:
                                              SharedSize.textFiledTitleSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const MyVerticalSpacer(),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 14, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //from camera

                                      TaskOptionsWidget(
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
                                          ],
                                          child: const MediaOptionWidget(
                                            icon: Icons.camera_alt,
                                            label: 'كاميرا',
                                            color: Colors.blue,
                                            onTap: null,
                                          )),

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
                                          addTaskSubmissionCubit
                                              .requestPermission(
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
                                  // addTaskSubmissionCubit:
                                  //     addTaskSubmissionCubit,
                                  // taskSubmissionModel: taskSubmissionModel,
                                  storagePath:
                                      EndPointsConstants.taskSubmissionsStorage,
                                  oldSubmissionAttachmentsCategories:
                                      taskSubmissionModel
                                          ?.submissionAttachmentsCategories,
                                  pickedImagesList:
                                      addTaskSubmissionCubit.pickedImagesList,
                                  deletedPickedImageFromList:
                                      addTaskSubmissionCubit
                                          .deletedPickedImageFromList,
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                SelectedVideosWidget(
                                  pickedVideosList:
                                      addTaskSubmissionCubit.pickedVideosList,
                                  deletePickedVideoFromList:
                                      addTaskSubmissionCubit
                                          .deletePickedVideoFromList,
                                  oldSubmissionAttachmentsCategories:
                                      taskSubmissionModel
                                          ?.submissionAttachmentsCategories,
                                  videosControllers:
                                      addTaskSubmissionCubit.videosControllers,
                                  oldVideoControllers: addTaskSubmissionCubit
                                      .oldVideoControllers,
                                  toggleVideoPlayPause: addTaskSubmissionCubit
                                      .toggleVideoPlayPause,
                                ),
                                SelectedAttachmentsWidget(
                                  oldSubmissionAttachmentsCategories:
                                      taskSubmissionModel
                                          ?.submissionAttachmentsCategories,
                                  pickedFilesList:
                                      addTaskSubmissionCubit.pickedFilesList,
                                  deletedPickedFileFromList:
                                      addTaskSubmissionCubit
                                          .deletedPickedFileFromList,
                                ),
                                const Text(
                                  'إختيار الفئات',
                                  style: TextStyle(fontSize: 16),
                                ),
                                if (addTaskSubmissionCubit
                                        .getTaskCategoriesModel !=
                                    null)
                                  ...addTaskSubmissionCubit
                                      .getTaskCategoriesModel!.taskCategories!
                                      .map((TaskCategoryModel category) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: CheckboxListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              category.cName ?? 'Category name',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: addTaskSubmissionCubit
                                            .selectedTaskCategoriesList
                                            .contains(category),
                                        activeColor:
                                            ColorsConstants.primaryColor,
                                        checkColor: Colors.white,
                                        tileColor: Colors.grey[200],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8), // Rounded corners
                                        ),
                                        onChanged: (bool? value) {
                                          addTaskSubmissionCubit
                                              .checkBoxChanged(value, category);
                                        },
                                      ),
                                    );
                                  }),
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
                                    // isEdit: isEdit,
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
                                    scrollController: addTaskSubmissionCubit
                                        .scrollController);
                              }
                            },
                            // child: Text('add_task_submission_button_submit'.tr()),
                            isWidthFull: true,
                            buttonText: isEdit
                                ? 'تعديل التسليم'
                                : taskId == -1
                                    ? 'إضافة التسليم الجديد'
                                    : 'تسليم المهمة المكلف بها'),
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
