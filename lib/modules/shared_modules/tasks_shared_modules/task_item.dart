import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_dialog/my_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

import '../../../widgets/my_buttons/my_elevated_button.dart';

class TaskItem extends StatelessWidget {
  final TaskModel taskModel;

  // final bool isAddedByUser;   // or use role and permissions as global

  TaskItem({
    required this.taskModel,
    // this.isAddedByUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => myDialog(context,
          title: 'task_item_options_dialog_title'.tr(),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsScreen(
                        taskId: taskModel.tId!,
                      ),
                    ),
                  );
                },
                child: Text('task_item_options_dialog_view_details'.tr()),
              ),
              MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskScreen(
                        taskModel: taskModel,
                      ),
                    ),
                  );
                },
                child: Text('task_item_options_dialog_edit'.tr()),
              ),
            ],
          )),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      taskModel.tContent ?? 'content',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: TaskStatusEnum.getStatus(taskModel.tStatus).statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      TaskStatusEnum.getStatus(taskModel.tStatus).statusAr ?? 'status',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const MyVerticalSpacer(),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Start:  ${MyDateUtils.formatDateTime(taskModel.tPlanedStartTime)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'End:    ${MyDateUtils.formatDateTime(taskModel.tPlanedEndTime)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              MyVerticalSpacer(),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                      'Category: ${taskModel.taskCategory?.cName ?? 'undefined'}'),
                ],
              ),
              MyVerticalSpacer(),
              Text(
                'Assigned To: ${taskModel.assignedToUsers?.map((user) => user.name).join(', ')}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                'Added by: ${taskModel.addedByUser?.name}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              MyVerticalSpacer(),
              Divider(),
              const Text(
                'Supervisor Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskModel.tSupervisorNotes ?? ''),
              SizedBox(height: 10),
              const Text(
                'Manager Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskModel.tManagerNotes ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
