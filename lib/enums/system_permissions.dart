import 'package:jelanco_tracking_system/core/constants/user_data.dart';

class SystemPermissions {
  static const String addUser = 'اضافة مستخدم';
  static const String editUser = 'تعديل مستخدم';
  static const String deleteUser = 'حذف مستخدم';
  static const String editStatus = 'تعديل الحالة';
  static const String viewUsers = 'عرض المستخدمين';
  static const String addTask = 'اضافة تكليف';
  static const String editTask = 'تعديل تكليف';
  static const String deleteTask = 'حذف تكليف'; // will not be used
  static const String viewTasks = 'عرض التكليفات'; // will not be used in mobile
  static const String assignTask = 'تعيين تكليف';
  static const String submitTask = 'تسليم تكليف';
  static const String addTaskCategory = 'اضافة فئة تكليف'; // since it is optional
  static const String editTaskCategory = 'تعديل فئة تكليف'; // since it is optional
  static const String viewTaskCategories = 'عرض فئات التكليفات';
  static const String addComment = 'اضافة تعليق';
  static const String addRole = 'اضافة دور';
  static const String editRole = 'تعديل دور';
  static const String viewRoles = 'عرض الادوار';
  static const String editSubmission = 'تعديل تسليم تكليف';
  static const String viewComments = 'عرض التعليقات';

  // static const String viewMyEmployeesSubmissions = 'عرض تسليمات موظفيني'; //used in back-end // all submissions of my employees (even tasks assigned by another manager)
  static const String viewSubmissions =
      'عرض التسليمات'; // my submissions + all submissions of my employees / if he has the permission (even tasks assigned by another manager)
  static const String viewManagerUsers = 'متابعة الموظفين'; // عرض موظفين المدير
  static const String viewTasksAssignedToMe = 'عرض تكليفاتي'; // عرض المهام الموكلة إلي or submitTask
  static const String usersFollowUpManagement = 'تعيين متابعين';

  static bool hasPermission(String permission) {
    return UserDataConstants.permissionsList!.contains(permission);
  }

  static bool hasAllPermissions(List<String> requiredPermissions) {
    return requiredPermissions.every((permission) => UserDataConstants.permissionsList!.contains(permission));
  }
}
