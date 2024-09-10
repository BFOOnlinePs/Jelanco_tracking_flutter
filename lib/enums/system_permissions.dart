import 'package:jelanco_tracking_system/core/constants/user_data.dart';

class SystemPermissions {
  // permissions form database
  static const String addUser = 'اضافة مستخدم';
  static const String editUser = 'تعديل مستخدم';
  static const String deleteUser = 'حذف مستخدم';
  static const String editStatus = 'تعديل الحالة';
  static const String viewUsers = 'عرض المستخدمين';
  static const String addTask = 'اضافة مهمة';
  static const String editTask = 'تعديل مهمة';
  static const String deleteTask = 'حذف مهمة'; // will not be used
  static const String viewTasks = 'عرض المهام'; // will not be used
  static const String assignTask = 'تعيين مهمة';
  static const String submitTask = 'تسليم مهمة';
  static const String addTaskCategory = 'اضافة فئة لمهمة'; // since it is optional
  static const String editTaskCategory = 'تعديل فئة لمهمة'; // since it is optional
  static const String viewTaskCategories = 'عرض فئات المهام';
  static const String addComment = 'اضافة تعليق';
  static const String addRole = 'اضافة دور';
  static const String editRole = 'تعديل دور';
  static const String viewRoles = 'عرض الادوار';
  // not added in database yet
  static const String editSubmission = 'تعديل تسليم';
  static const String viewComments = 'عرض التعليقات';
  static const String viewMyEmployeesSubmissions = 'عرض تسليمات موظفيني'; // all submissions of my employees (even tasks assigned by another manager)


  static bool hasPermission(String permission) {
    return UserDataConstants.permissionsList!.contains(permission);
  }

  static bool hasAllPermissions(List<String> requiredPermissions) {
    return requiredPermissions.every((permission) =>
        UserDataConstants.permissionsList!.contains(permission));
  }
}
