import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_screen.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_attachments_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_images_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_videos_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_horizontal_spacer.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../widgets/my_buttons/my_elevated_button.dart';

class EditTaskScreen extends StatelessWidget {
  final int taskId;
  final Function(TaskModel)? getDataCallback; // to get the data after edit task

  EditTaskScreen({
    super.key,
    required this.taskId,
    required this.getDataCallback,
  });

  late EditTaskCubit editTaskCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTaskCubit()
        ..getOldTaskData(
          taskId: taskId,
        ).then((_) {
          editTaskCubit.getTaskCategories(
            loadingState: CategoriesLoadingState(),
            successState: CategoriesSuccessState(),
            errorState: (error) => CategoriesErrorState(error: error),
          );
          editTaskCubit.getManagerEmployeesWithTaskAssignees(
            taskId: taskId,
            loadingState: GetManagerEmployeesLoadingState(),
            successState: GetManagerEmployeesSuccessState(),
            errorState: GetManagerEmployeesErrorState(),
          );
        }),
      child: BlocConsumer<EditTaskCubit, EditTaskStates>(
        listener: (context, state) {
          print(state);
          print('getOldTaskDataByIdModel: ${editTaskCubit.getOldTaskDataByIdModel?.toMap()}');

          // if (state is GetAllUsersSuccessState) {
          //   // editTaskCubit.users = editTaskCubit.getAllUsersModel!.users!;
          //   // editTaskCubit.filteredUsers = editTaskCubit.users;
          // } else

          if (state is GetManagerEmployeesSuccessState) {
            // to display the old assigned to users
            editTaskCubit.selectedUsers = editTaskCubit
                .getManagerEmployeesWithTaskAssigneesModel!.managerEmployees!
                .where((user) => editTaskCubit.getOldTaskDataByIdModel!.task!.assignedToUsers!
                    .any((assignedUser) => assignedUser.id == user.id))
                .toList();
          } else if (state is CategoriesSuccessState) {
            print('state is CategoriesSuccessState');
            print(editTaskCubit.getOldTaskDataByIdModel?.task?.tCategoryId);
            print('getOldTaskDataByIdModel: ${editTaskCubit.getOldTaskDataByIdModel?.toMap()}');

            // to display the old category
            editTaskCubit.selectedCategory = editTaskCubit.getOldTaskDataByIdModel?.task?.tCategoryId == null
                ? null
                : editTaskCubit.getTaskCategoriesModel!.taskCategories!.firstWhere(
                    (category) => category.cId == editTaskCubit.getOldTaskDataByIdModel!.task!.tCategoryId);
          } else if (state is EditTaskSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.success,
              message: state.editTaskModel.message,
            );

            // Trigger the callback when popping
            if (getDataCallback != null) {
              getDataCallback!(state.editTaskModel.task!);
            }

            Navigator.pop(context);
          } else if (state is EditTaskErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: state.error,
            );
          } else if (state is CategoriesErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: state.error,
            );
          } else if (state is GetManagerEmployeesErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: 'ERROR !',
            );
          }
        },
        builder: (context, state) {
          editTaskCubit = EditTaskCubit.get(context);

          return Scaffold(
            appBar: const MyAppBar(
              title: 'تعديل التكليف',
            ),
            body: Stack(
              children: [
                MyScreen(
                  // padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: editTaskCubit.editTaskFormKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('الموظفين المكلفين',
                                        style: TextStyle(fontSize: SharedSize.textFiledTitleSize)),
                                    Text(
                                      ' *',
                                      style: TextStyle(
                                          fontSize: SharedSize.textFiledTitleSize, color: Colors.red),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                                const SizedBox(
                                  height: TextFormFieldSizeConstants.sizedBoxHeight,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return AssignedToScreen(
                                            isAddTask: true,
                                            users: editTaskCubit
                                                .getManagerEmployeesWithTaskAssigneesModel!.managerEmployees!,
                                            selectedUsers: editTaskCubit.selectedUsers,
                                          );
                                        },
                                      ),
                                    ).then((value) {
                                      editTaskCubit.emitAfterReturn();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              editTaskCubit.selectedUsers.isEmpty
                                                  ? 'الموظفين المكلفين'
                                                  : editTaskCubit.selectedUsers
                                                      .map((user) => user.name)
                                                      .join(', '),
                                              style: const TextStyle(color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
                                ),
                                const MyVerticalSpacer(),
                                MyTextFormField(
                                    titleText: 'محتوى التكليف',
                                    labelText: 'أكتب محتوى التكليف',
                                    controller: editTaskCubit.contentController,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    isFieldRequired: true,
                                    maxLines: 3,
                                    // onChanged: (value) => editTaskCubit.content = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يجب كتابة محتوى التكليف';
                                      }
                                      return null;
                                    }),
                                const MyVerticalSpacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyTextFormField(
                                        titleText: 'موعد البدء',
                                        labelText: 'إختر الموعد',
                                        readOnly: true,
                                        onTap: () => editTaskCubit.selectDateTime(context, true,
                                            editTaskCubit.getOldTaskDataByIdModel!.task!.createdAt),
                                        // validator: (value) =>
                                        //     editTaskCubit.plannedStartTime == null
                                        //         ? 'Select a start time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: editTaskCubit.plannedStartTime != null
                                                ? MyDateUtils.formatDateTime(editTaskCubit.plannedStartTime)
                                                : ''),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const MyHorizontalSpacer(),
                                    Expanded(
                                      child: MyTextFormField(
                                        titleText: 'موعد الإنتهاء',
                                        labelText: 'إختر الموعد',
                                        readOnly: true,
                                        onTap: () => editTaskCubit.selectDateTime(context, false,
                                            editTaskCubit.getOldTaskDataByIdModel!.task!.createdAt),
                                        // validator: (value) =>
                                        //     editTaskCubit.plannedEndTime == null
                                        //         ? 'Select an end time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: editTaskCubit.plannedEndTime != null
                                                ? MyDateUtils.formatDateTime(editTaskCubit.plannedEndTime)
                                                : ''),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                MyDropdownButton<TaskCategoryModel>(
                                  label: 'التصنيف',
                                  hint: 'إختر التصنيف',
                                  items: editTaskCubit.getTaskCategoriesModel?.taskCategories ?? [],
                                  onChanged: (value) {
                                    editTaskCubit.changeSelectedCategory(newSelectedCategory: value);
                                  },
                                  value: editTaskCubit.selectedCategory,
                                  displayText: (TaskCategoryModel taskCategory) => taskCategory.cName ?? '',
                                  // validator: (value) =>
                                  //     value == null ? 'Select a category' : null,
                                ),
                                const MyVerticalSpacer(),
                                // MyDropdownButton<TaskStatusEnum>(
                                //   label: 'الحالة',
                                //   displayText: (status) => status.statusAr,
                                //   value: TaskStatusEnum.getStatus(
                                //       taskModel.tStatus ?? ''),
                                //   onChanged: (TaskStatusEnum? newStatus) {
                                //     editTaskCubit.changeSelectedTaskStatus(
                                //         taskStatusEnum: newStatus!);
                                //   },
                                //   items: TaskStatusEnum.getAllStatuses(),
                                // ),
                                // const MyVerticalSpacer(),

                                const MyVerticalSpacer(),
                                Container(
                                  margin: const EdgeInsets.only(top: 14, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //from camera

                                      OptionsWidget(
                                          menuItems: [
                                            MenuItemModel(
                                              icon: Icons.image,
                                              iconColor: Colors.green,
                                              label: 'إلتقاط صورة',
                                              onTap: () {
                                                editTaskCubit.requestPermission(
                                                    context: context,
                                                    permissionType: PermissionType.camera,
                                                    functionWhenGranted: editTaskCubit.pickMediaFromCamera);
                                              },
                                            ),
                                            MenuItemModel(
                                              icon: Icons.video_camera_back,
                                              label: 'إلتقاط فيديو',
                                              iconColor: Colors.red,
                                              onTap: () {
                                                editTaskCubit.requestPermission(
                                                    context: context,
                                                    permissionType: PermissionType.camera,
                                                    functionWhenGranted: () =>
                                                        editTaskCubit.pickMediaFromCamera(isImage: false));
                                              },
                                            ),
                                          ],
                                          child: const MediaOptionWidget(
                                            icon: Icons.camera_alt,
                                            label: 'كاميرا',
                                            color: Colors.blue,
                                            onTap: null,
                                          )),

                                      Container(width: 0.2, height: 26, color: Colors.grey),

                                      MediaOptionWidget(
                                        icon: Icons.image,
                                        label: 'صورة',
                                        color: Colors.green,
                                        onTap: () {
                                          editTaskCubit.requestPermission(
                                              context: context,
                                              permissionType: PermissionType.storage,
                                              functionWhenGranted:
                                                  editTaskCubit.pickMultipleImagesFromGallery);
                                        },
                                      ),
                                      Container(width: 0.2, height: 26, color: Colors.grey),
                                      MediaOptionWidget(
                                        icon: Icons.video_camera_back,
                                        label: 'فيديو',
                                        color: Colors.red,
                                        onTap: () {
                                          editTaskCubit.requestPermission(
                                              context: context,
                                              permissionType: PermissionType.storage,
                                              functionWhenGranted: editTaskCubit.pickVideoFromGallery);
                                        },
                                      ),
                                      Container(width: 0.2, height: 26, color: Colors.grey),
                                      MediaOptionWidget(
                                        icon: Icons.attach_file,
                                        label: 'ملف',
                                        color: Colors.blue,
                                        onTap: () {
                                          editTaskCubit.requestPermission(
                                              context: context,
                                              permissionType: PermissionType.storage,
                                              functionWhenGranted: editTaskCubit.pickReportFile);
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SelectedImagesWidget(
                                  storagePath: EndPointsConstants.tasksStorage,
                                  // old not used yet since the task has no version
                                  oldSubmissionAttachmentsCategories:
                                      editTaskCubit.getOldTaskDataByIdModel?.task?.taskAttachmentsCategories,
                                  pickedImagesList: editTaskCubit.pickedImagesList,
                                  deletedPickedImageFromList: editTaskCubit.deletePickedImageFromList,
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                SelectedVideosWidget(
                                  pickedVideosList: editTaskCubit.pickedVideosList,
                                  deletePickedVideoFromList: editTaskCubit.deletePickedVideoFromList,
                                  oldVideoControllers: editTaskCubit.oldVideoControllers,
                                  oldSubmissionAttachmentsCategories:
                                      editTaskCubit.getOldTaskDataByIdModel?.task?.taskAttachmentsCategories,
                                  videosControllers: editTaskCubit.videosControllers,
                                  toggleVideoPlayPause: editTaskCubit.toggleVideoPlayPause,
                                ),
                                SelectedAttachmentsWidget(
                                  pickedFilesList: editTaskCubit.pickedFilesList,
                                  // old not used yet since the task has no version
                                  oldSubmissionAttachmentsCategories:
                                      editTaskCubit.getOldTaskDataByIdModel?.task?.taskAttachmentsCategories,
                                  deletedPickedFileFromList: editTaskCubit.deletedPickedFileFromList,
                                ),
                              ],
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          onPressed: () {
                            if (editTaskCubit.editTaskFormKey.currentState!.validate()) {
                              editTaskCubit.editTask(
                                taskId: editTaskCubit.getOldTaskDataByIdModel!.task!.tId!,
                                oldAttachments: [
                                  ...editTaskCubit
                                      .getOldTaskDataByIdModel!.task!.taskAttachmentsCategories!.images!
                                      .map((e) => e.aAttachment!),
                                  ...editTaskCubit
                                      .getOldTaskDataByIdModel!.task!.taskAttachmentsCategories!.videos!
                                      .map((e) => e.aAttachment!),
                                  ...editTaskCubit
                                      .getOldTaskDataByIdModel!.task!.taskAttachmentsCategories!.files!
                                      .map((e) => e.aAttachment!),
                                ],
                              );
                            }
                          },
                          isWidthFull: true,
                          buttonText: 'تعديل التكليف',
                        ),
                      ],
                    ),
                  ),
                ),
                state is EditTaskLoadingState ||
                        state is GetOldTaskDataLoadingState ||
                        editTaskCubit.getTaskCategoriesModel == null ||
                        editTaskCubit.getManagerEmployeesWithTaskAssigneesModel == null
                    ? LoaderWithDisable(
                        isShowMessage: state is EditTaskLoadingState ? true : false,
                      )
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }
}
