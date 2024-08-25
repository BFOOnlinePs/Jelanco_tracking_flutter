import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_cubit.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_item.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';

class AssignedTasksScreen extends StatelessWidget {
  AssignedTasksScreen({super.key});

  late AssignedTasksCubit assignedTasksCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'assigned_tasks_title'.tr()),
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
                      : ListView.builder(
                          itemCount: assignedTasksCubit
                              .getTasksAssignedToUserModel!.tasks!.length,
                          itemBuilder: (context, index) {
                            return TaskItem(
                              taskModel: assignedTasksCubit
                                  .getTasksAssignedToUserModel!.tasks![index],
                            );
                          },
                        ),
                );
        },
      ),
    );
  }
}
