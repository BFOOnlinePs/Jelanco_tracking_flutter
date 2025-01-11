import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/all_users_selection_modules/all_users_selection_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_attachments_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_images_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/selected_media_widgets/selected_videos_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/error_text/my_error_field_text.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_horizontal_spacer.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../core/constants/button_size.dart';
import 'add_task_widgets/assigned_to_screen.dart';

class AddTaskScreen extends StatelessWidget {
  final int? initialSelectedUserId; // when add task to a specific user from profile screen

  AddTaskScreen({super.key, this.initialSelectedUserId});

  late AddTaskCubit addTaskCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit()
        ..getTaskCategories(
          loadingState: CategoriesLoadingState(),
          successState: CategoriesSuccessState(),
          errorState: (error) => CategoriesErrorState(error: error),
        )
        ..getManagerEmployees(
          loadingState: GetManagerEmployeesLoadingState(),
          successState: GetManagerEmployeesSuccessState(),
          errorState: GetManagerEmployeesErrorState(),
        ),
      child: BlocConsumer<AddTaskCubit, AddTaskStates>(
        listener: (context, state) {
          print('hi');
          print(state);
          if (state is GetManagerEmployeesSuccessState) {
            // addTaskCubit.users = addTaskCubit.getAllUsersModel!.users!;
            // addTaskCubit.filteredUsers = addTaskCubit.users;
            if (initialSelectedUserId != null) {
              addTaskCubit.addInitialSelectedUser(userId: initialSelectedUserId!);
            }
          } else if (state is AddTaskSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.success,
              message: state.addTaskModel.message,
            );
            NavigationServices.back(context);
            NavigationServices.navigateTo(
              context,
              TaskDetailsScreen(taskId: state.addTaskModel.task!.tId!),
            );
          } else if (state is AddTaskErrorState) {
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
            SnackbarHelper.showSnackbar(context: context, snackBarStates: SnackBarStates.error, message: 'ERROR !!');
          }
        },
        builder: (context, state) {
          addTaskCubit = AddTaskCubit.get(context);

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: MyAppBar(
                title: 'add_task_title'.tr(),
              ),
              body: Stack(
                children: [
                  MyScreen(
                    // padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: addTaskCubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('add_task_assign_to_field'.tr(), style: TextStyle(fontSize: SharedSize.textFiledTitleSize)),
                                          Text(
                                            ' *',
                                            style: TextStyle(fontSize: SharedSize.textFiledTitleSize, color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            // addTaskCubit.users = addTaskCubit.getAllUsersModel!.users!;
                                            // addTaskCubit.filteredUsers = addTaskCubit.users;
                                            return AssignedToScreen(
                                              isAddTask: true,
                                              // onSelected: (selectedUsers) {
                                              //   addTaskCubit.emitAfterReturn();
                                              // },
                                              users: addTaskCubit.getManagerEmployeesModel!.managerEmployees!,
                                              selectedUsers: addTaskCubit.selectedUsers,
                                            );
                                          },
                                        ),
                                      ).then((_) {
                                        // This code will run when the AnotherScreen is popped off the stack
                                        addTaskCubit.emitAfterReturn();
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
                                                  addTaskCubit.selectedUsers.isEmpty
                                                      ? 'add_task_assign_to_field'.tr()
                                                      : addTaskCubit.selectedUsers.map((user) => user.name).join(', '),
                                                  style: const TextStyle(color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward),
                                          ],
                                        )),
                                  ),
                                  // addTaskCubit.addTaskModel != null &&
                                  addTaskCubit.isAddClicked && addTaskCubit.selectedUsers.isEmpty
                                      ? MyErrorFieldText(text: 'add_task_assign_to_field_required_validation'.tr())
                                      : Container(),
                                  const MyVerticalSpacer(),
                                  // interested parties
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('الإشارات والوسوم', style: TextStyle(fontSize: SharedSize.textFiledTitleSize)),
                                          // Text(
                                          //   ' *',
                                          //   style: TextStyle(fontSize: SharedSize.textFiledTitleSize, color: Colors.red),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AllUsersSelectionScreen(
                                              callInterestedParties: false,
                                              selectedUsersList: addTaskCubit.selectedInterestedParties.map((user) => user.id!).toList(),
                                            );
                                          },
                                        ),
                                      ).then((result) {
                                        print('popped');
                                        // This code will run when the AnotherScreen is popped off the stack
                                        if (result == null) return;
                                        addTaskCubit.selectedInterestedParties = result;
                                        addTaskCubit.emitAfterReturn();
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
                                                  addTaskCubit.selectedInterestedParties.isEmpty
                                                      ? 'الإشارات والوسوم'
                                                      : addTaskCubit.selectedInterestedParties.map((user) => user.name).join(', '),
                                                  style: const TextStyle(color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward),
                                          ],
                                        )),
                                  ),
                                  // enable if interested parties if required
                                  // addTaskCubit.isAddClicked && addTaskCubit.selectedInterestedParties.isEmpty
                                  //     ? MyErrorFieldText(
                                  //     text: 'add_task_assign_to_field_required_validation'.tr())
                                  //     : Container(),
                                  const MyVerticalSpacer(),

                                  MyTextFormField(
                                    titleText: 'add_task_content_field'.tr(),
                                    labelText: 'add_task_content_field_label'.tr(),
                                    controller: addTaskCubit.contentController,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    isFieldRequired: true,
                                    maxLines: 3,
                                    // onChanged: (value) => addTaskCubit.content = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'add_task_content_field_required_validation'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  const MyVerticalSpacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyTextFormField(
                                          titleText: 'add_task_start_time_field'.tr(),
                                          labelText: 'add_task_start_time_field_label'.tr(),
                                          readOnly: true,
                                          onTap: () => addTaskCubit.selectDateTime(context, true),
                                          // validator: (value) =>
                                          //     addTaskCubit.plannedStartTime == null
                                          //         ? 'Select a start time'
                                          //         : null,
                                          controller: TextEditingController(
                                              text: addTaskCubit.plannedStartTime != null
                                                  ? MyDateUtils.formatDateTime(addTaskCubit.plannedStartTime!)
                                                  : ''),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const MyHorizontalSpacer(),
                                      Expanded(
                                        child: MyTextFormField(
                                          titleText: 'add_task_end_time_field'.tr(),
                                          labelText: 'add_task_end_time_field_label'.tr(),
                                          readOnly: true,
                                          onTap: () => addTaskCubit.selectDateTime(context, false),
                                          // validator: (value) =>
                                          //     addTaskCubit.plannedEndTime == null
                                          //         ? 'Select an end time'
                                          //         : null,
                                          controller: TextEditingController(
                                              text: addTaskCubit.plannedEndTime != null
                                                  ? MyDateUtils.formatDateTime(addTaskCubit.plannedEndTime!)
                                                  : ''),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const MyVerticalSpacer(),
                                  MyDropdownButton<TaskCategoryModel>(
                                    label: 'add_task_category_field'.tr(),
                                    hint: 'add_task_category_field_hint'.tr(),
                                    items: addTaskCubit.getTaskCategoriesModel?.taskCategories ?? [],
                                    onChanged: (value) {
                                      addTaskCubit.changeSelectedCategory(newSelectedCategory: value);
                                    },
                                    value: addTaskCubit.selectedCategory,
                                    displayText: (TaskCategoryModel taskCategory) => taskCategory.cName ?? '',
                                    // validator: (value) =>
                                    //     value == null ? 'Select a category' : null,
                                  ),
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
                                                  addTaskCubit.requestPermission(
                                                      context: context,
                                                      permissionType: PermissionType.camera,
                                                      functionWhenGranted: addTaskCubit.pickMediaFromCamera);
                                                },
                                              ),
                                              MenuItemModel(
                                                icon: Icons.video_camera_back,
                                                label: 'إلتقاط فيديو',
                                                iconColor: Colors.red,
                                                onTap: () {
                                                  addTaskCubit.requestPermission(
                                                      context: context,
                                                      permissionType: PermissionType.camera,
                                                      functionWhenGranted: () => addTaskCubit.pickMediaFromCamera(isImage: false));
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
                                            addTaskCubit.requestPermission(
                                                context: context,
                                                permissionType: PermissionType.storage,
                                                functionWhenGranted: addTaskCubit.pickMultipleImagesFromGallery);
                                          },
                                        ),
                                        Container(width: 0.2, height: 26, color: Colors.grey),
                                        MediaOptionWidget(
                                          icon: Icons.video_camera_back,
                                          label: 'فيديو',
                                          color: Colors.red,
                                          onTap: () {
                                            addTaskCubit.requestPermission(
                                                context: context,
                                                permissionType: PermissionType.storage,
                                                functionWhenGranted: addTaskCubit.pickVideoFromGallery);
                                          },
                                        ),
                                        Container(width: 0.2, height: 26, color: Colors.grey),
                                        MediaOptionWidget(
                                          icon: Icons.attach_file,
                                          label: 'ملف',
                                          color: Colors.blue,
                                          onTap: () {
                                            addTaskCubit.requestPermission(
                                                context: context,
                                                permissionType: PermissionType.storage,
                                                functionWhenGranted: addTaskCubit.pickReportFile);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SelectedImagesWidget(
                                    storagePath: EndPointsConstants.tasksStorage,
                                    // old not used yet since the task has no version
                                    // oldSubmissionAttachmentsCategories: taskSubmissionModel?.submissionAttachmentsCategories ,
                                    pickedImagesList: addTaskCubit.pickedImagesList,
                                    deletedPickedImageFromList: addTaskCubit.deletePickedImageFromList,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  SelectedVideosWidget(
                                    pickedVideosList: addTaskCubit.pickedVideosList,
                                    deletePickedVideoFromList: addTaskCubit.deletePickedVideoFromList,
                                    oldVideoControllers: addTaskCubit.oldVideoControllers,
                                    // oldSubmissionAttachmentsCategories: taskSubmissionModel?.submissionAttachmentsCategories,
                                    videosControllers: addTaskCubit.videosControllers,
                                    toggleVideoPlayPause: addTaskCubit.toggleVideoPlayPause,
                                  ),
                                  SelectedAttachmentsWidget(
                                    pickedFilesList: addTaskCubit.pickedFilesList,
                                    // old not used yet since the task has no version
                                    deletedPickedFileFromList: addTaskCubit.deletedPickedFileFromList,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          MyElevatedButton(
                            onPressed: () {
                              addTaskCubit.changeIsAddClicked(true);
                              if (addTaskCubit.formKey.currentState!.validate()) {
                                addTaskCubit.isAddTaskSubmissionLoading = true;
                                addTaskCubit.emitLoading();
                                addTaskCubit.addTask();
                              }
                            },
                            // child: Text('add_task_add_button'.tr()),
                            isWidthFull: true,
                            buttonText: 'add_task_add_button'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addTaskCubit.isAddTaskSubmissionLoading ||
                          addTaskCubit.getTaskCategoriesModel == null ||
                          addTaskCubit.getManagerEmployeesModel == null
                      ? LoaderWithDisable(
                          isShowMessage: addTaskCubit.isAddTaskSubmissionLoading ? true : false,
                        )
                      : Container()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
