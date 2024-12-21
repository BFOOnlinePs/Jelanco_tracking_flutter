import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_card_widget.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/add_user_screen.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/cubit/users_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/cubit/users_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersManagementCubit()
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(),
        ),
      child: BlocConsumer<UsersManagementCubit, UsersManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UsersManagementCubit usersManagementCubit = UsersManagementCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(
              title: 'إدارة الموظفين',
            ),
            body: MyScreen(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    usersManagementCubit.getAllUsersModel == null
                        ? const MyLoader()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: usersManagementCubit.getAllUsersModel?.users?.length ?? 0,
                              itemBuilder: (context, index) => UserCardWidget(
                                userModel: usersManagementCubit.getAllUsersModel!.users![index],
                                showEditButton: true,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
            floatingActionButton: MyFloatingActionButton(
                icon: Icons.add,
                labelText: 'إضافة موظف',
                onPressed: () {
                  NavigationServices.navigateTo(context, const AddUserScreen());
                }),
          );
        },
      ),
    );
  }
}
