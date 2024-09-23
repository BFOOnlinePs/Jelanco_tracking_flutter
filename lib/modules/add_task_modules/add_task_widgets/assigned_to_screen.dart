import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_states/assigned_to_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_states/assigned_to_states.dart';

class AssignedToScreen extends StatelessWidget {
  final bool isAddTask;
  final List<UserModel> users;
  final List<UserModel> selectedUsers;

  AssignedToScreen({
    super.key,
    required this.isAddTask,
    required this.users,
    required this.selectedUsers,
  });

  late AssignedToCubit assignedToCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('assigned_to_title'.tr()),
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
                      hintText: 'assigned_to_search_box'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            ButtonSizeConstants.borderRadius),
                      ),
                    ),
                    onChanged: assignedToCubit.filterUsers,
                  ),
                ),
                Expanded(
                  child: assignedToCubit.filteredUsers.isEmpty ||
                          !SystemPermissions.hasPermission(
                              SystemPermissions.viewManagerUsers)
                      ? Center(
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Image(
                              image: AssetImage(
                                AssetsKeys.defaultNoUsersImage,
                              ),
                              height: 250,
                            ),
                            Text(assignedToCubit.filteredUsers.isEmpty
                                ? 'لا يوجد مستخدمين'
                                : 'ليست لديك صلاحية لرؤية المستخدمين'),
                          ],
                        ))
                      : ListView(
                          children: assignedToCubit.filteredUsers.map((user) {
                            return CheckboxListTile(
                              title: Text(user.name ?? 'name'),
                              value:
                                  assignedToCubit.selectedUsers.contains(user),
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
          // onSelected(assignedToCubit.selectedUsers);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
