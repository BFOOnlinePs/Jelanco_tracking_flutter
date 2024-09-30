import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/main.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class NotificationsUtils {
  static void navigateFromNotification({
    required int? notificationId,
    required String? type,
    required String? typeId,
  }) {
    if (notificationId != null) {
      markNotificationAsRead(notificationId);
    }

    if (type == null || typeId == null) return;

    final int parsedId = int.tryParse(typeId) ?? 0;

    // Navigate based on the type and pass the id if available
    switch (type) {
      case 'task':
        navigateToScreen(TaskDetailsScreen(taskId: parsedId));
        break;
      case 'submission':
      case 'comment':
        navigateToScreen(TaskSubmissionDetailsScreen(submissionId: parsedId));
        break;
      case 'general_screen':
        print('Navigate to general screen');
        // Implement general screen navigation
        break;
      default:
        print('Unknown notification type: $type');
    }
  }

  static void markNotificationAsRead(int notificationId) {
    // Implement notification reading logic
    DioHelper.getData(url: '${EndPointsConstants.readNotifications}/$notificationId').then((value) {
      print(value?.data);
    }).catchError((error) {
      print(error.toString());
    });
  }

  static void navigateToScreen(Widget screen) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => screen));
  }
}
