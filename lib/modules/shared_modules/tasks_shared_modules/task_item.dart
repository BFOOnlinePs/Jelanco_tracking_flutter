import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/widgets/my_dialog/my_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

import '../../../widgets/my_buttons/my_elevated_button.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => myDialog(context,
          title: 'Task Options',
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TaskDetailsScreen(task: task),
                  //   ),
                  // );
                },
                child: Text('View Details'),
              ),
              MyElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditTaskScreen(task: task),
                  //   ),
                  // );
                },
                child: Text('Edit Task'),
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
                      task.tContent ?? 'content',
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
                      color:
                          task.tStatus == 'active' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.tStatus ?? 'status',
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
                    'Start:  ${MyDateUtils.formatDateTime(task.tPlanedStartTime)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'End:    ${MyDateUtils.formatDateTime(task.tPlanedEndTime)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              MyVerticalSpacer(),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Category: ${task.taskCategory?.cName ?? 'undefined'}'),
                ],
              ),
              MyVerticalSpacer(),
              Text(
                'Assigned To: ${task.assignedToNames!.join(', ')}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              const Text(
                'Supervisor Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(task.tSupervisorNotes ?? ''),
              SizedBox(height: 10),
              const Text(
                'Manager Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(task.tManagerNotes ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
