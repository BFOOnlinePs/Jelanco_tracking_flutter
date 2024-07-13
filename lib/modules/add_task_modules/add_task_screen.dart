import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/task_categories_models/get_task_categories_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import 'add_task_widgets/assigned_to_screen.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit()..getTaskCategories(),
      child: BlocConsumer<AddTaskCubit, AddTaskStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AddTaskCubit addTaskCubit = AddTaskCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('Add Task'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: addTaskCubit.formKey,
                  child: Column(
                    children: [
                      MyTextFormField(
                        titleText: 'Task Content',
                        labelText: 'Enter task content',
                        isFieldRequired: true,
                        maxLines: 3,
                        onChanged: (value) => addTaskCubit.content = value,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter task content' : null,
                      ),
                      // const MyVerticalSpacer(),
                      MyTextFormField(
                        titleText: 'Planned Start Time',
                        labelText: 'Select the task planned start time',
                        readOnly: true,
                        onTap: () => addTaskCubit.selectDateTime(context, true),
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
                        items: addTaskCubit
                                .getTaskCategoriesModel?.taskCategories ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            addTaskCubit.selectedCategory = value;
                          });
                        },
                        value: addTaskCubit.selectedCategory,
                        displayText: (TaskCategoryModel taskCategory) =>
                            taskCategory.cName ?? '',
                        // validator: (value) =>
                        //     value == null ? 'Select a category' : null,
                      ),

                      const MyVerticalSpacer(),

                      // Assigned To Dropdown (Multi-select)
                      GestureDetector(
                        onTap: () {
                          // Navigate to a new screen or show a dialog for multi-select
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignedToScreen(
                                onSelected: (selectedUsers) {
                                  setState(() {
                                    addTaskCubit.assignedTo = selectedUsers;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                addTaskCubit.assignedTo.isEmpty
                                    ? 'Assigned To'
                                    : addTaskCubit.assignedTo.join(', '),
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
                          if (addTaskCubit.formKey.currentState!.validate()) {
                            // Handle form submission
                            // print('Task added: $content');
                            // print('Start Time: $plannedStartTime');
                            // print('End Time: $plannedEndTime');
                            // print('Category: $selectedCategory');
                            // print('Assigned To: $assignedTo');
                          }
                        },
                        child: Text('Add Task'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
