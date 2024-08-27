import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_cubit.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_item.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

class AssignedTasksScreen extends StatelessWidget {
  final bool showAppBar;

  AssignedTasksScreen({super.key, this.showAppBar = true});

  late AssignedTasksCubit assignedTasksCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? MyAppBar(title: 'assigned_tasks_title'.tr()) : null,
      body: BlocConsumer<AssignedTasksCubit, AssignedTasksStates>(
        listener: (context, state) {},
        builder: (context, state) {
          assignedTasksCubit = AssignedTasksCubit.get(context);
          return assignedTasksCubit.getTasksAssignedToUserModel == null
              ? const Center(child: MyLoader())
              : Container(
                  child: assignedTasksCubit
                          .getTasksAssignedToUserModel!.tasks!.isEmpty
                      ? Center(child: Text('assigned_tasks_no_tasks'.tr()))
                      : MyRefreshIndicator(
                          onRefresh: () async {
                            await assignedTasksCubit.getAssignedTasks();
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: assignedTasksCubit
                                    .tasksAssignedToUserList.length +
                                (assignedTasksCubit.isTasksAssignedToUserLastPage
                                    ? 0
                                    : 1),
                            itemBuilder: (context, index) {
                              if (index ==
                                      assignedTasksCubit
                                          .tasksAssignedToUserList.length &&
                                  !assignedTasksCubit
                                      .isTasksAssignedToUserLastPage) {
                                if (!assignedTasksCubit
                                    .isTasksAssignedToUserLoading) {
                                  assignedTasksCubit.getAssignedTasks(
                                    page: assignedTasksCubit
                                            .getTasksAssignedToUserModel!
                                            .pagination!
                                            .currentPage! +
                                        1,
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return TaskItem(
                                  taskModel: assignedTasksCubit
                                      .tasksAssignedToUserList[index]);
                            },
                          ),
                        ),
                );
        },
      ),
    );
  }
}
