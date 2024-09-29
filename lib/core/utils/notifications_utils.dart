import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/main.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';

class NotificationsUtils {
  static void navigateFromNotification({
    required String? type,
    required String? typeId,
  }) {
    if (type == null || typeId == null) return;

    final int parsedId = int.tryParse(typeId) ?? 0;

    // Navigate based on the type and pass the id if available
    switch (type) {
      case 'task':
        _navigateToScreen(TaskDetailsScreen(taskId: parsedId));
        break;
      case 'submission':
      case 'comment':
        _navigateToScreen(TaskSubmissionDetailsScreen(submissionId: parsedId));
        break;
      case 'general_screen':
        print('Navigate to general screen');
        // Implement general screen navigation
        break;
      default:
        print('Unknown notification type: $type');
    }
  }

  static void _navigateToScreen(Widget screen) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => screen));
  }
}
