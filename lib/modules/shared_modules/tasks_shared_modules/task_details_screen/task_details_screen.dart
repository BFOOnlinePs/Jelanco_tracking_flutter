import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submissions_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

import '../../../../core/utils/navigation_services.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  late TaskDetailsCubit taskDetailsCubit;

  TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailsCubit()
        ..getTaskWithSubmissionsAndComments(taskId: taskId)
        ..listenToNewComments(),
      child: BlocConsumer<TaskDetailsCubit, TaskDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          taskDetailsCubit = TaskDetailsCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(
              title: 'تفاصيل التكليف',
            ),
            body: taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel == null
                ? const Center(
                    child: MyLoader(),
                  )
                : MyRefreshIndicator(
                    onRefresh: () async {
                      await taskDetailsCubit.getTaskWithSubmissionsAndComments(taskId: taskId);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: taskDetailsCubit.scrollController,
                      // padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskDetailsSectionWidget(
                            taskModel: taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!,
                          ),
                          taskDetailsCubit
                                  .getTaskWithSubmissionsAndCommentsModel!.task!.taskSubmissions!.isNotEmpty
                              ? SubmissionsSectionWidget(
                                  taskDetailsCubit: taskDetailsCubit,
                                )
                              : Container(),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
            floatingActionButton: taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel == null
                ? Center(
                    child: Container(),
                  )
                : SystemPermissions.hasPermission(SystemPermissions.submitTask) &&
                        FormatUtils.checkIfNumberInList(
                            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!.tAssignedTo!,
                            UserDataConstants.userId!)
                    ? MyFloatingActionButton(
                        onPressed: () {
                          NavigationServices.navigateTo(
                            context,
                            AddTaskSubmissionScreen(
                              taskId: taskId,
                              getDataCallback: (taskSubmissionModel) {
                                print('call the data');
                                taskDetailsCubit.getTaskWithSubmissionsAndComments(taskId: taskId);
                                // scroll to the beginning
                                ScrollUtils.scrollPosition(
                                    scrollController: taskDetailsCubit.scrollController);
                              },
                            ),
                          );
                        },
                        labelText: 'تسليم المهمة المكلف بها',
                        icon: Icons.check_circle_outline,
                      )
                    : Container(),
          );
        },
      ),
    );
  }
}
