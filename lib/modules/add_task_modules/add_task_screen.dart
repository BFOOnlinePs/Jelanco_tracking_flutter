import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
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
  final int?
      initialSelectedUserId; // when add task to a specific user from profile screen

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
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(error: error),
        ),
      child: BlocConsumer<AddTaskCubit, AddTaskStates>(
        listener: (context, state) {
          print('hi');
          print(state);
          if (state is GetAllUsersSuccessState) {
            // addTaskCubit.users = addTaskCubit.getAllUsersModel!.users!;
            // addTaskCubit.filteredUsers = addTaskCubit.users;
            if (initialSelectedUserId != null) {
              addTaskCubit.addInitialSelectedUser(
                  userId: initialSelectedUserId!);
            }
          } else if (state is AddTaskSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.success,
              message: state.addTaskModel.message,
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
          } else if (state is GetAllUsersErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: state.error,
            );
          }
        },
        builder: (context, state) {
          addTaskCubit = AddTaskCubit.get(context);

          return Scaffold(
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
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('add_task_assign_to_field'.tr(),
                                            style: TextStyle(
                                                fontSize: SharedSize
                                                    .textFiledTitleSize)),
                                        Text(
                                          ' *',
                                          style: TextStyle(
                                              fontSize:
                                                  SharedSize.textFiledTitleSize,
                                              color: Colors.red),
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
                                            onSelected: (selectedUsers) {
                                              addTaskCubit.changeSelectedUsers(
                                                  selectedUsers);
                                            },
                                            users: addTaskCubit
                                                .getAllUsersModel!.users!,
                                            selectedUsers:
                                                addTaskCubit.selectedUsers,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
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
                                                addTaskCubit
                                                        .selectedUsers.isEmpty
                                                    ? 'add_task_assign_to_field'
                                                        .tr()
                                                    : addTaskCubit.selectedUsers
                                                        .map(
                                                            (user) => user.name)
                                                        .join(', '),
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward),
                                        ],
                                      )),
                                ),
                                // addTaskCubit.addTaskModel != null &&
                                addTaskCubit.isAddClicked &&
                                        addTaskCubit.selectedUsers.isEmpty
                                    ? MyErrorFieldText(
                                        text:
                                            'add_task_assign_to_field_required_validation'
                                                .tr())
                                    : Container(),
                                const MyVerticalSpacer(),
                                MyTextFormField(
                                  titleText: 'add_task_content_field'.tr(),
                                  labelText:
                                      'add_task_content_field_label'.tr(),
                                  controller: addTaskCubit.contentController,
                                  textInputAction: TextInputAction.newline,
                                  keyboardType: TextInputType.multiline,
                                  isFieldRequired: true,
                                  maxLines: 3,
                                  // onChanged: (value) => addTaskCubit.content = value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'add_task_content_field_required_validation'
                                          .tr();
                                    }
                                    return null;
                                  },
                                ),
                                const MyVerticalSpacer(),
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
                                        onTap: () => addTaskCubit
                                            .selectDateTime(context, true),
                                        // validator: (value) =>
                                        //     addTaskCubit.plannedStartTime == null
                                        //         ? 'Select a start time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: addTaskCubit
                                                        .plannedStartTime !=
                                                    null
                                                ? MyDateUtils.formatDateTime(
                                                    addTaskCubit
                                                        .plannedStartTime!)
                                                : ''),
                                        style: const TextStyle(
                                          fontSize: 14,
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
                                        onTap: () => addTaskCubit
                                            .selectDateTime(context, false),
                                        // validator: (value) =>
                                        //     addTaskCubit.plannedEndTime == null
                                        //         ? 'Select an end time'
                                        //         : null,
                                        controller: TextEditingController(
                                            text: addTaskCubit.plannedEndTime !=
                                                    null
                                                ? MyDateUtils.formatDateTime(
                                                    addTaskCubit
                                                        .plannedEndTime!)
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
                                  items: addTaskCubit.getTaskCategoriesModel
                                          ?.taskCategories ??
                                      [],
                                  onChanged: (value) {
                                    addTaskCubit.changeSelectedCategory(
                                        newSelectedCategory: value);
                                  },
                                  value: addTaskCubit.selectedCategory,
                                  displayText:
                                      (TaskCategoryModel taskCategory) =>
                                          taskCategory.cName ?? '',
                                  // validator: (value) =>
                                  //     value == null ? 'Select a category' : null,
                                ),
                                const MyVerticalSpacer(),
                              ],
                            ),
                          ),
                        ),
                        MyElevatedButton(
                          onPressed: () {
                            addTaskCubit.changeIsAddClicked(true);
                            if (addTaskCubit.formKey.currentState!.validate()) {
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
                state is AddTaskLoadingState ||
                        addTaskCubit.getTaskCategoriesModel == null ||
                        addTaskCubit.getAllUsersModel == null
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
