import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_screen.dart';

import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_states.dart';
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
  final TaskModel taskModel;

  EditTaskScreen({super.key, required this.taskModel});

  late EditTaskCubit editTaskCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTaskCubit()
        ..initialValues(
          content: taskModel.tContent,
          startTime: taskModel.tPlanedStartTime,
          endTime: taskModel.tPlanedEndTime,
          taskStatus: TaskStatusEnum.getStatus(taskModel.tStatus!),
        )
        ..getTaskCategories(
          loadingState: CategoriesLoadingState(),
          successState: CategoriesSuccessState(),
          errorState: (error) => CategoriesErrorState(error: error),
        )
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(error: error),
        ),
      child: BlocConsumer<EditTaskCubit, EditTaskStates>(
        listener: (context, state) {
          print('hi');
          print(state);
          // if (state is GetAllUsersSuccessState) {
          //   // addTaskCubit.users = addTaskCubit.getAllUsersModel!.users!;
          //   // addTaskCubit.filteredUsers = addTaskCubit.users;
          // } else

          if (state is GetAllUsersSuccessState) {
            // to display the old assigned to users
            editTaskCubit.selectedUsers = editTaskCubit.getAllUsersModel!.users!
                .where((user) => taskModel.assignedToUsers!
                    .any((assignedUser) => assignedUser.id == user.id))
                .toList();
          } else if (state is CategoriesSuccessState) {
            // to display the old category
            editTaskCubit.selectedCategory = taskModel.tCategoryId == null
                ? null
                : editTaskCubit.getTaskCategoriesModel!.taskCategories!
                    .firstWhere(
                        (category) => category.cId == taskModel.tCategoryId);
          } else if (state is EditTaskSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.success,
              message: state.editTaskModel.message,
            );
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
          } else if (state is GetAllUsersErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          editTaskCubit = EditTaskCubit.get(context);

          return Scaffold(
            appBar: MyAppBar(
              title: 'تعديل المهمة',
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
                                        style: TextStyle(
                                            fontSize: SharedSize.textFiledTitleSize)),
                                    Text(
                                      ' *',
                                      style:
                                          TextStyle(fontSize: 16, color: Colors.red),
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                                SizedBox(
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
                                            onSelected: (selectedUsers) {
                                              editTaskCubit
                                                  .changeSelectedUsers(selectedUsers);
                                              // editTaskCubit.selectedUsers =
                                              //     selectedUsers;
                                            },
                                            users: editTaskCubit
                                                .getAllUsersModel!.users!,
                                            selectedUsers:
                                                editTaskCubit.selectedUsers,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          ButtonSizeConstants.borderRadius),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
                                ),
                                MyVerticalSpacer(),
                                MyTextFormField(
                                    titleText: 'محتوى المهمة',
                                    labelText: 'أكتب محتوى المهمة',
                                    controller: editTaskCubit.contentController,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    isFieldRequired: true,
                                    maxLines: 3,
                                    // onChanged: (value) => addTaskCubit.content = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يجب كتابة محتوى المهمة';
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
                                        onTap: () => editTaskCubit.selectDateTime(
                                            context, true, taskModel),
                                        // validator: (value) =>
                                        //     editTaskCubit.plannedStartTime == null
                                        //         ? 'Select a start time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: editTaskCubit.plannedStartTime !=
                                                    null
                                                ? MyDateUtils.formatDateTime(
                                                    editTaskCubit.plannedStartTime)
                                                : ''),
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    MyHorizontalSpacer(),
                                    Expanded(
                                      child: MyTextFormField(
                                        titleText: 'موعد الإنتهاء',
                                        labelText: 'إختر الموعد',
                                        readOnly: true,
                                        onTap: () => editTaskCubit.selectDateTime(
                                            context, false, taskModel),
                                        // validator: (value) =>
                                        //     editTaskCubit.plannedEndTime == null
                                        //         ? 'Select an end time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: editTaskCubit.plannedEndTime != null
                                                ? MyDateUtils.formatDateTime(
                                                    editTaskCubit.plannedEndTime)
                                                : ''),
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                MyDropdownButton<TaskCategoryModel>(
                                  label: 'التصنيف',
                                  hint: 'إختر التصنيف',
                                  items: editTaskCubit
                                          .getTaskCategoriesModel?.taskCategories ??
                                      [],
                                  onChanged: (value) {
                                    editTaskCubit.changeSelectedCategory(
                                        newSelectedCategory: value);
                                  },
                                  value: editTaskCubit.selectedCategory,
                                  displayText: (TaskCategoryModel taskCategory) =>
                                      taskCategory.cName ?? '',
                                  // validator: (value) =>
                                  //     value == null ? 'Select a category' : null,
                                ),

                                const MyVerticalSpacer(),

                                MyDropdownButton<TaskStatusEnum>(
                                  label: 'الحالة',
                                  displayText: (status) => status.statusAr,
                                  value: TaskStatusEnum.getStatus(
                                      taskModel.tStatus ?? ''),
                                  onChanged: (TaskStatusEnum? newStatus) {
                                    editTaskCubit.changeSelectedTaskStatus(
                                        taskStatusEnum: newStatus!);
                                  },
                                  items: TaskStatusEnum.getAllStatuses(),
                                ),

                                MyVerticalSpacer(),


                              ],
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          onPressed: () {
                            if (editTaskCubit.editTaskFormKey.currentState!
                                .validate()) {
                              editTaskCubit.editTask(taskId: taskModel.tId!);
                            }
                          },
                          isWidthFull: true,
                          buttonText: 'تعديل المهمة',

                        ),
                      ],
                    ),
                  ),
                ),
                state is EditTaskLoadingState ||
                        editTaskCubit.getTaskCategoriesModel == null ||
                        editTaskCubit.getAllUsersModel == null
                    ? const LoaderWithDisable()
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }
}
