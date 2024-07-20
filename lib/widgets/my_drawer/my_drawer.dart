import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
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
                message: 'حدث خطأ أثناء تسجيل الخروج، حاول لاحقاً.',
              );
            }
          } else  if (state is LogoutErrorState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: SnackBarStates.error,
              message: 'حدث خطأ أثناء تسجيل الخروج، حاول لاحقاً.',
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
                        child: const Column(
                          children: [
                            // CircleAvatar(
                            //   radius: 40,
                            //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                            // ),
                            SizedBox(height: 26),
                            Text(
                              'Username',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              'email@example.com',
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
                              text: 'Add Task',
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  AddTaskScreen(),
                                );
                              },
                            ),
                            DrawerItem(
                              icon: Icons.task_alt,
                              text: 'Tasks I Added',
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  TasksAddedByUserScreen(),
                                );
                              },
                            ),
                            DrawerItem(
                              icon: Icons.task_alt,
                              text: 'Assigned Tasks',
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  AssignedTasksScreen(),
                                );
                              },
                            ),
                            DrawerItem(
                              icon: Icons.logout,
                              text: 'تسجيل الخروج',
                              onTap: () {
                                drawerCubit.userLogout();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline),
                            SizedBox(width: 10),
                            Text('Version 1.0.0'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
