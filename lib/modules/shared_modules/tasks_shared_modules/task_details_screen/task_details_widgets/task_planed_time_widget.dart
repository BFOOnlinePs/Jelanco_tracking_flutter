import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';

class TaskPlanedTimeWidget extends StatelessWidget {
  final TaskModel taskModel;

  const TaskPlanedTimeWidget({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        taskModel.tPlanedStartTime != null
            ? Expanded(
                child: TimeWidget('وقت البدء المخطط له',
                    taskModel.tPlanedStartTime!, Icons.timer),
              )
            : Container(),
        taskModel.tPlanedStartTime != null && taskModel.tPlanedEndTime != null
            ? const SizedBox(width: 10)
            : Container(),
        taskModel.tPlanedEndTime != null
            ? Expanded(
                child: TimeWidget('وقت الانتهاء المخطط له',
                    taskModel.tPlanedEndTime!, Icons.timer_off),
              )
            : Container(),
      ],
    );
  }
}
