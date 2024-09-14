import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';

class TaskToSubmitCardWidget extends StatelessWidget {
  final TaskModel task;

  const TaskToSubmitCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationServices.navigateTo(
            context, TaskDetailsScreen(taskId: task.tId!));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 6.h),
        decoration: BoxDecoration(
          gradient: ColorsConstants.myLinearGradient,
          borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.0.w),
            // Add padding inside the Card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  print(constraints.minHeight);
                  print(constraints.maxHeight);
                  print(constraints.minWidth);
                  print(constraints.maxWidth);
                  return Text(
                    '> بواسطة: ${task.addedByUser?.name ?? ''}',
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: constraints.maxWidth < 300 ? 12.sp : 14.sp),
                  );
                }),
                LayoutBuilder(
                  builder: (context, constraints) => Text(
                    task.tContent ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxWidth < 300 ? 12.sp : 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
