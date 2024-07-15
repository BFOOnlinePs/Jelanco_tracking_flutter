import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../core/constants/button_size.dart';
import 'add_task_widgets/assigned_to_screen.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

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
            addTaskCubit.users = addTaskCubit.getAllUsersModel!.users!;
            addTaskCubit.filteredUsers = addTaskCubit.users;
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
            appBar: AppBar(
              title: Text('Add Task'),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: addTaskCubit.formKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                              titleText: 'Task Content',
                              labelText: 'Enter task content',
                              controller: addTaskCubit.contentController,
                              isFieldRequired: true,
                              maxLines: 3,
                              // onChanged: (value) => addTaskCubit.content = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter task content';
                                }
                              }),
                          // const MyVerticalSpacer(),
                          MyTextFormField(
                            titleText: 'Planned Start Time',
                            labelText: 'Select the task planned start time',
                            readOnly: true,
                            onTap: () =>
                                addTaskCubit.selectDateTime(context, true),
                            validator: (value) =>
                                addTaskCubit.plannedStartTime == null
                                    ? 'Select a start time'
                                    : null,
                            controller: TextEditingController(
                                text: addTaskCubit.plannedStartTime != null
                                    ? addTaskCubit.plannedStartTime!.toString()
                                    : ''),
                          ),
                          // const MyVerticalSpacer(),
                          MyTextFormField(
                            titleText: 'Planned End Time',
                            labelText: 'Select the task planned end time',
                            readOnly: true,
                            onTap: () =>
                                addTaskCubit.selectDateTime(context, false),
                            validator: (value) =>
                                addTaskCubit.plannedEndTime == null
                                    ? 'Select an end time'
                                    : null,
                            controller: TextEditingController(
                                text: addTaskCubit.plannedEndTime != null
                                    ? addTaskCubit.plannedEndTime!.toString()
                                    : ''),
                          ),

                          MyDropdownButton<TaskCategoryModel>(
                            label: 'Category',
                            hint: 'Select the task category',
                            items: addTaskCubit
                                    .getTaskCategoriesModel?.taskCategories ??
                                [],
                            onChanged: (value) {
                              addTaskCubit.selectedCategory = value;
                            },
                            value: addTaskCubit.selectedCategory,
                            displayText: (TaskCategoryModel taskCategory) =>
                                taskCategory.cName ?? '',
                            // validator: (value) =>
                            //     value == null ? 'Select a category' : null,
                          ),

                          const MyVerticalSpacer(),
                          Row(
                            children: [
                              Text('Assigned to',
                                  style: TextStyle(
                                      fontSize: SharedSize.textFiledTitleSize)),
                              // Text(
                              //   ' *',
                              //   style: TextStyle(fontSize: 16, color: Colors.red),
                              // ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                          value: addTaskCubit,
                                          child: AssignedToScreen(
                                              // onSelected: (selectedUsers) {
                                              //   setState(() {
                                              //     addTaskCubit.assignedTo =
                                              //         selectedUsers;
                                              //   });
                                              // },
                                              ),
                                        )),
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
                                  Text(
                                    addTaskCubit.selectedUsers.isEmpty
                                        ? 'Assigned To'
                                        : addTaskCubit.selectedUsers
                                            .map((user) => user.name)
                                            .join(', '),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          // Submit Button
                          ElevatedButton(
                            onPressed: () {
                              if (addTaskCubit.formKey.currentState!
                                  .validate()) {
                                addTaskCubit.addTask();
                              }
                            },
                            child: Text('Add Task'),
                          ),
                        ],
                      ),
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
