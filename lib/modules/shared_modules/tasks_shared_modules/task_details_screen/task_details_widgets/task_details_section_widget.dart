import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_added_by_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/wrapped_label_value_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/category_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_planed_time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskDetailsSectionWidget extends StatelessWidget {
  final TaskModel taskModel;

  const TaskDetailsSectionWidget({
    super.key,
    required this.taskModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: 10, start: 16, end: 16, bottom: 8),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskAddedBySectionWidget(taskModel),
          ContentWidget(
            taskModel.tContent!,
          ),
          MediaWidget(
            attachmentsCategories: taskModel.taskAttachmentsCategories,
            storagePath: EndPointsConstants.tasksStorage,
          ),
          taskModel.taskCategory != null
              ? CategoryRowWidget('التصنيف', taskModel.taskCategory!.cName ?? '')
              : Container(),
          taskModel.assignedToUsers!.isNotEmpty
              ? WrappedLabelValueWidget(
                  'الموظفين المكلفين', taskModel.assignedToUsers!.map((user) => user.name).join(', ') ?? '')
              : Container(),
          const MyVerticalSpacer(),
          TaskPlanedTimeWidget(taskModel: taskModel),
          const MyVerticalSpacer(),
        ],
      ),
    );
  }
}
