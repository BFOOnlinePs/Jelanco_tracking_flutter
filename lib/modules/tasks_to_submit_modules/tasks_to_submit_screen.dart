import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/cubit/tasks_to_submit_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/cubit/tasks_to_submit_states.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/task_to_submit_card_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';

// it needs pagination
class TasksToSubmitScreen extends StatelessWidget {
  TasksToSubmitScreen({super.key});

  late TasksToSubmitCubit tasksToSubmitCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'تكليفات بانتظار التسليم',
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
              child: MyRefreshIndicator(
                  onRefresh: () async {
                    await tasksToSubmitCubit.getTasksToSubmit(
                      loadingState: GetTasksToSubmitLoadingState(),
                      successState: GetTasksToSubmitSuccessState(),
                      errorState: (error) => GetTasksToSubmitErrorState(error),
                    );
                  },
                  child: tasksToSubmitCubit.getTasksToSubmitModel != null
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: tasksToSubmitCubit
                                  .tasksAssignedToUserList.length +
                              (tasksToSubmitCubit.isTasksAssignedToUserLastPage
                                  ? 0
                                  : 1),
                          itemBuilder: (context, index) {
                            if (index ==
                                    tasksToSubmitCubit
                                        .tasksAssignedToUserList.length &&
                                !tasksToSubmitCubit
                                    .isTasksAssignedToUserLastPage) {
                              if (!tasksToSubmitCubit
                                  .isTasksAssignedToUserLoading) {
                                tasksToSubmitCubit.getTasksToSubmit(
                                  loadingState: GetTasksToSubmitLoadingState(),
                                  successState: GetTasksToSubmitSuccessState(),
                                  errorState: (error) =>
                                      GetTasksToSubmitErrorState(error),
                                  page: tasksToSubmitCubit
                                          .getTasksToSubmitModel!
                                          .pagination!
                                          .currentPage! +
                                      1,
                                );
                              }
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: MyLoader()),
                              );
                            }
                            return TaskToSubmitCardWidget(
                                task: tasksToSubmitCubit
                                    .tasksAssignedToUserList[index]);
                          },
                        )
                      : const Center(child: MyLoader())
                  ),
            );
          },
        ),
      ),
    );
  }
}
