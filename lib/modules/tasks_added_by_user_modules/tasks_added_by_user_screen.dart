import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_screen.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

import '../shared_modules/tasks_shared_modules/task_item.dart';

// المهام التي أضفتها
class TasksAddedByUserScreen extends StatelessWidget {
  final bool showAppBar;

  const TasksAddedByUserScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? MyAppBar(
              title: 'tasks_i_added_title'.tr(),
            )
          : null,
      body: BlocProvider(
        create: (context) => TasksAddedByUserCubit()..getTasksAddedByUser(),
        child: BlocConsumer<TasksAddedByUserCubit, TasksAddedByUserStates>(
          listener: (context, state) {},
          builder: (context, state) {
            TasksAddedByUserCubit tasksAddedByUserCubit = TasksAddedByUserCubit.get(context);
            return tasksAddedByUserCubit.getTasksAddedByUserModel == null
                ? const Center(
                    child: MyLoader(),
                  )
                : Container(
                    child: tasksAddedByUserCubit.getTasksAddedByUserModel!.tasks!.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AssetsKeys.defaultNoTasksImage,
                                height: 250,
                              ),
                              Text('tasks_i_added_no_tasks'.tr()),
                            ],
                          ))
                        : MyRefreshIndicator(
                            onRefresh: () async {
                              await tasksAddedByUserCubit.getTasksAddedByUser();
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: tasksAddedByUserCubit.tasksAddedByUserList.length +
                                  (tasksAddedByUserCubit.isTasksAddedByUserLastPage ? 0 : 1),
                              itemBuilder: (context, index) {
                                if (index == tasksAddedByUserCubit.tasksAddedByUserList.length &&
                                    !tasksAddedByUserCubit.isTasksAddedByUserLastPage) {
                                  if (!tasksAddedByUserCubit.isTasksAddedByUserLoading) {
                                    tasksAddedByUserCubit.getTasksAddedByUser(
                                      page: tasksAddedByUserCubit.getTasksAddedByUserModel!.pagination!.currentPage! + 1,
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: MyLoader()),
                                  );
                                }
                                return TaskItem(taskModel: tasksAddedByUserCubit.tasksAddedByUserList[index]);
                              },
                            ),
                          ),
                  );
          },
        ),
      ),
      floatingActionButton: (SystemPermissions.hasPermission(SystemPermissions.addTask))
          ? MyFloatingActionButton(
              icon: Icons.add_task,
              labelText: 'إضافة تكليف',
              onPressed: () {
                NavigationServices.navigateTo(
                  context,
                  AddTaskScreen(),
                );
              },
            )
          : Container(),
    );
  }
}
