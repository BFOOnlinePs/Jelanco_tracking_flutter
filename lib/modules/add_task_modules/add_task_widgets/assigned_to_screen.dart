import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/button_size.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_cubit/assigned_to_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_cubit/assigned_to_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/check_box_user_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

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
            return MyScreen(
              child: Column(
                children: [
                  MyTextFormField(
                    labelText: 'إبحث عن موظف',
                    onChanged: assignedToCubit.filterUsers,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       hintText: 'assigned_to_search_box'.tr(),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(ButtonSizeConstants.borderRadius),
                  //       ),
                  //     ),
                  //     onChanged: assignedToCubit.filterUsers,
                  //   ),
                  // ),
                  Expanded(
                    child: assignedToCubit.filteredUsers.isEmpty || !SystemPermissions.hasPermission(SystemPermissions.viewManagerUsers)
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
                                Text(assignedToCubit.filteredUsers.isEmpty ? 'لا يوجد مستخدمين' : 'ليس لديك صلاحية لمتابعة الموظفين'),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: assignedToCubit.filteredUsers.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              UserModel user = assignedToCubit.filteredUsers[index];
                              return CheckBoxUserWidget(
                                  user: user,
                                  value: assignedToCubit.selectedUsers.contains(user),
                                  onChanged: (bool? value) {
                                    assignedToCubit.checkBoxChanged(value, user);
                                  });
                            },
                          ),
                  ),
                ],
              ),
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
