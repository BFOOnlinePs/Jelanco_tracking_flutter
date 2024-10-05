import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_states.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';

class UsersFollowUpManagementScreen extends StatelessWidget {
  const UsersFollowUpManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUpManagementCubit()..getManagers(),
      child: BlocConsumer<FollowUpManagementCubit, FollowUpManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FollowUpManagementCubit followUpManagementCubit = FollowUpManagementCubit.get(context);
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('تعيين المتابعين'),
                ),
                body: Column(
                  children: [
                    followUpManagementCubit.filteredUsers.isEmpty &&
                            followUpManagementCubit.searchText.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'بحث عن مستخدم',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: followUpManagementCubit.usersSearch,
                            ),
                          ),
                    Expanded(
                      child: followUpManagementCubit.filteredUsers.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage(
                                    AssetsKeys.defaultNoUsersImage,
                                  ),
                                  height: 250,
                                ),
                                Text('لا يوجد متابعين'),
                              ],
                            ))
                          : ListView.builder(
                              itemCount: followUpManagementCubit.filteredUsers.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title:
                                      Text(followUpManagementCubit.filteredUsers[index].name ?? 'user name'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // // Navigate to edit screen with the selected user
                                      followUpManagementCubit.navigateToEditAddScreen(
                                          context, followUpManagementCubit.filteredUsers[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                floatingActionButton: MyFloatingActionButton(
                  icon: Icons.add,
                  labelText: 'متابع جديد',
                  onPressed: () {
                    // // Navigate to add a new user
                    followUpManagementCubit.navigateToEditAddScreen(context, null);
                  },
                ),
              ),
              state is GetManagersLoadingState ? const LoaderWithDisable() : Container(),
            ],
          );
        },
      ),
    );
  }
}
