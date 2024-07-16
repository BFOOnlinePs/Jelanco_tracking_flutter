import 'package:flutter/material.dart';

class TaskStatusEnum {
  final String statusName; // in database
  final String statusAr;
  final String statusEn;
  final Color statusColor;

  const TaskStatusEnum({
    required this.statusName,
    required this.statusAr,
    required this.statusEn,
    required this.statusColor,
  });

  static const TaskStatusEnum active = TaskStatusEnum(
    statusName: 'active',
    statusAr: 'مفعل',
    statusEn: 'active',
    statusColor: Colors.green,
  );
  static const TaskStatusEnum notActive = TaskStatusEnum(
    statusName: 'notActive',
    statusAr: 'غير مفعل',
    statusEn: 'not active',
    statusColor: Colors.red,
  );

  static const TaskStatusEnum undefined = TaskStatusEnum(
    statusName: 'undefined',
    statusAr: 'غير معرف',
    statusEn: 'undefined',
    statusColor: Colors.grey,
  );

  static List<TaskStatusEnum> getAllStatuses() {
    return [active, notActive];
  }

  static TaskStatusEnum getStatus(String status) {
    switch (status) {
      case 'active':
        return active;
      case 'notActive':
        return notActive;
      default:
        return undefined;
    }
  }
}
