import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/task_details_section_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';
import 'package:jelanco_tracking_system/widgets/my_dialog/my_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskItem extends StatelessWidget {
  final TaskModel taskModel;

  // final bool isAddedByUser;   // or use role and permissions as global

  const TaskItem({
    super.key,
    required this.taskModel,
    // this.isAddedByUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationServices.navigateTo(
          context,
          TaskDetailsScreen(
            taskId: taskModel.tId!,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Same as the Card border radius

          child: TaskDetailsSectionWidget(
            taskModel: taskModel,
          ),
        ),
      ),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Expanded(
//       child: Text(
//         taskModel.tContent ?? 'content',
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//     const SizedBox(
//       width: 6,
//     ),
//     // Container(
//     //   padding:
//     //       const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//     //   decoration: BoxDecoration(
//     //     color: TaskStatusEnum.getStatus(taskModel.tStatus)
//     //         .statusColor,
//     //     borderRadius: BorderRadius.circular(12),
//     //   ),
//     //   child: Text(
//     //     TaskStatusEnum.getStatus(taskModel.tStatus).statusAr ??
//     //         'status',
//     //     style: const TextStyle(
//     //       color: Colors.white,
//     //       fontWeight: FontWeight.bold,
//     //     ),
//     //   ),
//     // ),
//   ],
// ),
// const MyVerticalSpacer(),
// taskModel.tPlanedStartTime != null
//     ? Row(
//         children: [
//           const Icon(Icons.calendar_today, color: Colors.grey),
//           const SizedBox(width: 8),
//           Text(
//             'تاريخ البدء:      ${MyDateUtils.formatDateTime(taskModel.tPlanedStartTime)}',
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ],
//       )
//     : Container(),
// taskModel.tPlanedEndTime != null
//     ? Row(
//         children: [
//           const Icon(Icons.calendar_today, color: Colors.grey),
//           const SizedBox(width: 8),
//           Text(
//             'تاريخ الإنتهاء:  ${MyDateUtils.formatDateTime(taskModel.tPlanedEndTime)}',
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ],
//       )
//     : Container(),
// taskModel.taskCategory != null
//     ? Column(
//         children: [
//           const MyVerticalSpacer(),
//           Row(
//             children: [
//               const Icon(Icons.category, color: Colors.grey),
//               const SizedBox(width: 8),
//               Text('التصنيف: ${taskModel.taskCategory?.cName}'),
//             ],
//           ),
//         ],
//       )
//     : Container(),
// const MyVerticalSpacer(),
// taskModel.assignedToUsers != null &&
//         taskModel.assignedToUsers!.isNotEmpty
//     ? Text(
//         'الموظفين المكلفين: ${taskModel.assignedToUsers?.map((user) => user.name).join(', ')}',
//         style: const TextStyle(
//           fontStyle: FontStyle.italic,
//           color: Colors.blueGrey,
//         ),
//       )
//     : Container(),
// taskModel.addedByUser != null
//     ? Text(
//         'أُضيف بواسطة: ${taskModel.addedByUser?.name}',
//         style: const TextStyle(
//           fontStyle: FontStyle.italic,
//           color: Colors.blueGrey,
//         ),
//       )
//     : Container(),



// MyVerticalSpacer(),
// Divider(),
// const Text(
//   'Supervisor Notes:',
//   style: TextStyle(fontWeight: FontWeight.bold),
// ),
// Text(taskModel.tSupervisorNotes ?? ''),
// SizedBox(height: 10),
// const Text(
//   'Manager Notes:',
//   style: TextStyle(fontWeight: FontWeight.bold),
// ),
// Text(taskModel.tManagerNotes ?? ''),
