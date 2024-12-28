import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_name_and_roles_widget.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/user_roles_and_permissions_management_screen.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';

class UserPermissionsManagementScreen extends StatelessWidget {
  const UserPermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserPermissionsManagementCubit()..getInitialData(),
      child: BlocConsumer<UserPermissionsManagementCubit, UserPermissionsManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserPermissionsManagementCubit userPermissionsManagementCubit = UserPermissionsManagementCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(title: 'إدارة صلاحيات المستخدمين'),
            body: MyScreen(
              child: Column(
                children: [
                  const Text('search box'),
                  Expanded(
                    child: userPermissionsManagementCubit.getAllUsersModel == null
                        ? const Center(child: MyLoader())
                        : ListView.builder(
                            itemCount: userPermissionsManagementCubit.usersList.length,
                            itemBuilder: (context, index) => GestureDetector(
                                child: UserNameAndRoleWidget(
                              user: userPermissionsManagementCubit.usersList[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: userPermissionsManagementCubit,
                                      child: UserRolesAndPermissionsManagementScreen(user: userPermissionsManagementCubit.usersList[index]),
                                    ),
                                  ),
                                );
                              },
                            )),
                          ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
