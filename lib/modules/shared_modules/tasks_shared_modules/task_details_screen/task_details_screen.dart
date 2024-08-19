import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submissions_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  late TaskDetailsCubit taskDetailsCubit;

  TaskDetailsScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'تفاصيل المهمة',
      ),
      body: BlocProvider(
        create: (context) => TaskDetailsCubit()
          ..getTaskWithSubmissionsAndComments(taskId: taskId),
        child: BlocConsumer<TaskDetailsCubit, TaskDetailsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            taskDetailsCubit = TaskDetailsCubit.get(context);
            return taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel ==
                    null
                ? Center(
                    child: MyLoader(),
                  )
                : Stack(
                  children: [
                    SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TaskDetailsSectionWidget(
                                taskDetailsCubit: taskDetailsCubit),
                            MyVerticalSpacer(),
                            MyVerticalSpacer(),
                            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                                    .task!.taskSubmissions!.isNotEmpty
                                ? SubmissionsSectionWidget(
                                    taskDetailsCubit: taskDetailsCubit)
                                : Container(),
                          ],
                        ),
                      ),
                    state is AddCommentLoadingState ? LoaderWithDisable() : Container(),

                  ],
                );
          },
        ),
      ),
    );
  }
}
