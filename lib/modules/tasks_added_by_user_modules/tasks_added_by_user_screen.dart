import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

import '../shared_modules/tasks_shared_modules/task_item.dart';

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
      body: BlocConsumer<TasksAddedByUserCubit, TasksAddedByUserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TasksAddedByUserCubit tasksAddedByUserCubit =
              TasksAddedByUserCubit.get(context);
          return tasksAddedByUserCubit.getTasksAddedByUserModel == null
              ? const Center(
                  child: MyLoader(),
                )
              : Container(
                  child: tasksAddedByUserCubit
                          .getTasksAddedByUserModel!.tasks!.isEmpty
                      ? Center(child: Text('tasks_i_added_no_tasks'.tr()))
                      : MyRefreshIndicator(
                          onRefresh: () async {
                            await tasksAddedByUserCubit.getTasksAddedByUser();
                          },
                          child: ListView.builder(
                            itemCount: tasksAddedByUserCubit
                                .getTasksAddedByUserModel!.tasks!.length,
                            itemBuilder: (context, index) {
                              return TaskItem(
                                taskModel: tasksAddedByUserCubit
                                    .getTasksAddedByUserModel!.tasks![index],
                              );
                            },
                          ),
                        ),
                );
        },
      ),
    );
  }
}
