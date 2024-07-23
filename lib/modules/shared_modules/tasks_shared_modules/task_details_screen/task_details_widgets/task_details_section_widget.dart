import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/assigned_to_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/category_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/notes_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskDetailsSectionWidget extends StatelessWidget {
  final TaskDetailsCubit taskDetailsCubit;
  const TaskDetailsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget('تفاصيل المهمة',
            status: TaskStatusEnum.getStatus(taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel!.task!.tStatus!),
            statusIcon: Icons.flag),
        ContentWidget(
            'Task Content',
            taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel!.task!.tContent!,
            Icons.description),
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
                .join(', ') ??
                '',
            Icons.person)
            : Container(),
        MyVerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                ?.tPlanedStartTime !=
                null
                ? Expanded(
              child: TimeWidget(
                  'وقت البدء المخطط له',
                  taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                      .task!.tPlanedStartTime!,
                  Icons.timer),
            )
                : Container(),
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                ?.tPlanedStartTime !=
                null &&
                taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                    .task?.tPlanedEndTime !=
                    null
                ? SizedBox(width: 10)
                : Container(),
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                ?.tPlanedEndTime !=
                null
                ? Expanded(
              child: TimeWidget(
                  'وقت الانتهاء المخطط له',
                  taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                      .task!.tPlanedEndTime!,
                  Icons.timer_off),
            )
                : Container(),
          ],
        ),
        MyVerticalSpacer(),
        // taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
        //     .tSupervisorNotes !=
        //     null
        //     ? NotesWidget(
        //   'Supervisor Notes',
        //   taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
        //       .tSupervisorNotes!,
        //   Icons.notes,
        // )
        //     : Container(),
        // taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
        //     .tManagerNotes !=
        //     null
        //     ? NotesWidget(
        //   'Manager Notes',
        //   taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
        //       .tManagerNotes!,
        //   Icons.notes,
        // )
        //     : Container(),
        // _buildDateRow('Created At', task.createdAt?.toString() ?? 'N/A',
        //     Icons.calendar_today),
        // _buildDateRow(
        //     'Updated At', task.updatedAt?.toString() ?? 'N/A', Icons.update),
      ],
    );
  }
}
