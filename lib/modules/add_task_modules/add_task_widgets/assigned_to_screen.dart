import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_states/assigned_to_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_states/assigned_to_states.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_cubit.dart';

import '../add_task_cubit/add_task_cubit.dart';

class AssignedToScreen extends StatelessWidget {
  final Function(List<UserModel>) onSelected;
  final bool isAddTask;
  final List<UserModel> users;
  final List<UserModel> selectedUsers;

  AssignedToScreen({
    super.key,
    required this.isAddTask,
    required this.onSelected,
    required this.users,
    required this.selectedUsers,
  });

  late AssignedToCubit assignedToCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign To'),
      ),
      body: BlocProvider(
        create: (context) => AssignedToCubit()
          ..initialValues(
            usersList: users,
            selectedUsersList: selectedUsers,
          ),
        child: BlocConsumer<AssignedToCubit, AssignedToStates>(
          listener: (context, state) {},
          builder: (context, state) {
            assignedToCubit = AssignedToCubit.get(context);
            return Column(
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
                    onChanged: assignedToCubit.filterUsers,
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: assignedToCubit.filteredUsers.map((user) {
                      return CheckboxListTile(
                        title: Text(user.name ?? 'name'),
                        value: assignedToCubit.selectedUsers.contains(user),
                        onChanged: (bool? value) {
                          assignedToCubit.checkBoxChanged(value, user);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onSelected(assignedToCubit.selectedUsers);
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );

    //   BlocConsumer<AddTaskCubit, AddTaskStates>(
    //   listener: (context, state) {},
    //   builder: (context, state) {
    //     if (isAddTask) {
    //       cubit = AddTaskCubit.get(context);
    //     } else {
    //       cubit = EditTaskCubit.get(context);
    //     }
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: Text('Assign To'),
    //       ),
    //       body: Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: TextField(
    //               decoration: InputDecoration(
    //                 hintText: 'Search users...',
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(
    //                       ButtonSizeConstants.borderRadius),
    //                 ),
    //               ),
    //               onChanged: cubit.filterUsers,
    //             ),
    //           ),
    //           Expanded(
    //             child: ListView(
    //               children: cubit.filteredUsers.map((user) {
    //                 return CheckboxListTile(
    //                   title: Text(user.name ?? 'name'),
    //                   value: cubit.selectedUsers.contains(user),
    //                   onChanged: (bool? value) {
    //                     cubit.checkBoxChanged(value, user );
    //                   },
    //                 );
    //               }).toList(),
    //             ),
    //           ),
    //         ],
    //       ),
    //       floatingActionButton: FloatingActionButton(
    //         onPressed: () {
    //           // widget.onSelected(cubit.selectedUsers);
    //           Navigator.pop(context);
    //         },
    //         child: Icon(Icons.check),
    //       ),
    //     );
    //   },
    // );
  }
}
