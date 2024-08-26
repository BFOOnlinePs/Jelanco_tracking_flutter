import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submissions_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

import '../../../../core/utils/navigation_services.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  late TaskDetailsCubit taskDetailsCubit;

  TaskDetailsScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
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
                      MyRefreshIndicator(
                        onRefresh: () async {
                          await taskDetailsCubit
                              .getTaskWithSubmissionsAndComments(
                                  taskId: taskId);
                        },
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TaskDetailsSectionWidget(
                                  taskDetailsCubit: taskDetailsCubit),
                              MyVerticalSpacer(),
                              MyVerticalSpacer(),
                              taskDetailsCubit
                                      .getTaskWithSubmissionsAndCommentsModel!
                                      .task!
                                      .taskSubmissions!
                                      .isNotEmpty
                                  ? SubmissionsSectionWidget(
                                      taskDetailsCubit: taskDetailsCubit)
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      // ..................................
                      // state is AddCommentLoadingState ? LoaderWithDisable() : Container(),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          NavigationServices.navigateTo(
              context,
              AddTaskSubmissionScreen(
                taskId: taskId,
              ));
        },
        // child: Row(
        //   children: [
        //     Text('تسليم المهمة'),
        //     Icon(Icons.check_circle_outline)
        //   ],
        // ),
        label: Text(
          'تسليم المهمة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // Add label text
        icon: Icon(Icons.check_circle_outline, color: Colors.white),
        // Add icon

        backgroundColor: ColorsConstants.primaryColor,
      ),
    );
  }
}
