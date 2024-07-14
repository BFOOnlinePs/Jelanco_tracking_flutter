import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';

import '../add_task_cubit/add_task_cubit.dart';

class AssignedToScreen extends StatefulWidget {
  // final Function(List<UserModel>) onSelected;

  AssignedToScreen();

  @override
  _AssignedToScreenState createState() => _AssignedToScreenState();
}

class _AssignedToScreenState extends State<AssignedToScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AddTaskCubit addTaskCubit = AddTaskCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Assign To'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          ButtonSizeConstants.borderRadius),
                    ),
                  ),
                  onChanged: addTaskCubit.filterUsers,
                ),
              ),
              Expanded(
                child: ListView(
                  children: addTaskCubit.filteredUsers.map((user) {
                    return CheckboxListTile(
                      title: Text(user.name ?? 'name'),
                      value: addTaskCubit.selectedUsers.contains(user),
                      onChanged: (bool? value) {
                        addTaskCubit.checkBoxChanged(value, user);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // widget.onSelected(addTaskCubit.selectedUsers);
              Navigator.pop(context);
            },
            child: Icon(Icons.check),
          ),
        );
      },
    );
  }
}
