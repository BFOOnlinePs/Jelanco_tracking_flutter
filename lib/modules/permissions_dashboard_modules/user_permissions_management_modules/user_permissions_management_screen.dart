import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';

class UserPermissionsManagementScreen extends StatelessWidget {
  const UserPermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserPermissionsManagementCubit()
          ..getAllUsers(
            // search: value,
            pagination: 1,
            isRole: 1,
            loadingState: GetAllUsersLoadingState(),
            successState: GetAllUsersSuccessState(),
            errorState: (error) => GetAllUsersErrorState(),
          ),
        child: BlocConsumer<UserPermissionsManagementCubit, UserPermissionsManagementStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return const MyScreen(child: Text('UserPermissionsManagementScreen'));
          },
        ));
  }
}
