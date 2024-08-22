import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_screen.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_screen.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_screen.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/drawer_cubit/drawer_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/drawer_cubit/drawer_states.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

import 'drawer_item.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: BlocConsumer<DrawerCubit, DrawerStates>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            if (state.userLogoutModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.userLogoutModel.message,
              );
              NavigationServices.navigateTo(context, LoginScreen());
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: 'drawer_logout_error'.tr(),
              );
            }
          } else if (state is LogoutErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: 'drawer_logout_error'.tr(),
            );
          }
        },
        builder: (context, state) {
          DrawerCubit drawerCubit = DrawerCubit.get(context);
          return state is LogoutLoadingState
              ? const Center(child: MyLoader())
              : Drawer(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          gradient: ColorsConstants.myLinearGradient,
                        ),
                        child:  Column(
                          children: [
                            // CircleAvatar(
                            //   radius: 40,
                            //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                            // ),
                            SizedBox(height: 26),
                            Text(
                              UserDataConstants.name ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              UserDataConstants.jobTitle ?? '',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              UserDataConstants.email ?? '',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DrawerItem(
                              icon: Icons.add_task,
                              text: 'drawer_add_task_title'.tr(),
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  AddTaskScreen(),
                                );
                              },
                            ),
                            DrawerItem(
                              icon: Icons.task_alt,
                              text: 'drawer_tasks_i_added_title'.tr(),
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  TasksAddedByUserScreen(),
                                );
                              },
                            ),
                            DrawerItem(
                              icon: Icons.task_alt,
                              text: 'drawer_tasks_assigned_to_me_title'.tr(),
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  AssignedTasksScreen(),
                                );
                              },
                            ),
                            // DrawerItem(
                            //   icon: Icons.logout,
                            //   text: 'drawer_logout_title'.tr(),
                            //   onTap: () {
                            //     drawerCubit.userLogout();
                            //   },
                            // ),
                          ],
                        ),
                      ),

                      DrawerItem(
                        icon: Icons.logout,
                        text: 'drawer_logout_title'.tr(),
                        onTap: () {
                          drawerCubit.userLogout();
                        },
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
