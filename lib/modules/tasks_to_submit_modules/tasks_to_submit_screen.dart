import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/cubit/tasks_to_submit_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/cubit/tasks_to_submit_states.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/task_to_submit_card_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';

class TasksToSubmitScreen extends StatelessWidget {
  TasksToSubmitScreen({super.key});

  late TasksToSubmitCubit tasksToSubmitCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'مهام بانتظار التسليم',
      ),
      body: BlocProvider(
        create: (context) => TasksToSubmitCubit()
          ..getTasksToSubmit(
            loadingState: GetTasksToSubmitLoadingState(),
            successState: GetTasksToSubmitSuccessState(),
            errorState: (error) => GetTasksToSubmitErrorState(error),
          ),
        child: BlocConsumer<TasksToSubmitCubit, TasksToSubmitStates>(
          listener: (context, state) {},
          builder: (context, state) {
            tasksToSubmitCubit = TasksToSubmitCubit.get(context);
            return MyScreen(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyRefreshIndicator(
                    onRefresh: () async {
                      await tasksToSubmitCubit.getTasksToSubmit(
                        loadingState: GetTasksToSubmitLoadingState(),
                        successState: GetTasksToSubmitSuccessState(),
                        errorState: (error) =>
                            GetTasksToSubmitErrorState(error),
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: tasksToSubmitCubit.getTasksToSubmitModel != null
                          ? Column(
                              children: [
                                ...tasksToSubmitCubit
                                    .getTasksToSubmitModel!.tasks!
                                    .map((task) {
                                  return TaskToSubmitCardWidget(task: task);
                                })
                              ],
                            )
                          : const LinearProgressIndicator(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
