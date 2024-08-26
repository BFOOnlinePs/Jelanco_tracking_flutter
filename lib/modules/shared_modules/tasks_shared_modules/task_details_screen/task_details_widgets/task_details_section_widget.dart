import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/added_by_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/assigned_to_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/category_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_planed_time_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskDetailsSectionWidget extends StatelessWidget {
  final TaskDetailsCubit taskDetailsCubit;

  const TaskDetailsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: 10, start: 16, end: 16),
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddedBySectionWidget(
              '${taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!.addedByUser?.name}',
              status: TaskStatusEnum.getStatus(taskDetailsCubit
                  .getTaskWithSubmissionsAndCommentsModel!.task!.tStatus!),
              statusIcon: Icons.flag),
          ContentWidget(
            taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel!.task!.tContent!,
          ),
          taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel?.task
                      ?.taskCategory !=
                  null
              ? CategoryRowWidget(
                  'التصنيف',
                  taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                          .taskCategory!.cName ??
                      '')
              : Container(),

          taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                  .assignedToUsers!.isNotEmpty
              ? AssignedToWidget(
                  'الموظفين المكلفين',
                  taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                          ?.assignedToUsers!
                          .map((user) => user.name)
                          .join('\n') ??
                      '',
                  Icons.person)
              : Container(),
          MyVerticalSpacer(),
          TaskPlanedTimeWidget(
              taskModel: taskDetailsCubit
                  .getTaskWithSubmissionsAndCommentsModel!.task!),
          // MyVerticalSpacer(),

          // _buildDateRow('Created At', task.createdAt?.toString() ?? 'N/A',
          //     Icons.calendar_today),
          // _buildDateRow(
          //     'Updated At', task.updatedAt?.toString() ?? 'N/A', Icons.update),
        ],
      ),
    );
  }
}
