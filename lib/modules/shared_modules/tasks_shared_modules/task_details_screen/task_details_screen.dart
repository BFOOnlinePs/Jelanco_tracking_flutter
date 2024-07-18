import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submissions_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

import '../../../../models/basic_models/submission_comment_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  late TaskDetailsCubit taskDetailsCubit;

  TaskDetailsScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Task Details',
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
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskDetailsSectionWidget(taskDetailsCubit: taskDetailsCubit),
                        MyVerticalSpacer(),
                        MyVerticalSpacer(),
                        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                                .task!.taskSubmissions!.isNotEmpty
                            ? SubmissionsSectionWidget(taskDetailsCubit: taskDetailsCubit)
                            : Container(),
                      ],
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for adding a new submission
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorsConstants.primaryColor,
      ),
    );
  }

}
