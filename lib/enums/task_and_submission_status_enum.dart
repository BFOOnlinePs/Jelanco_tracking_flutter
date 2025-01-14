import 'package:flutter/material.dart';

class TaskAndSubmissionStatusEnum {
  final int order;
  final String statusDBName; // in database
  final String statusAr;
  final String statusEn;
  final Color statusColor;
  final double percent;

  const TaskAndSubmissionStatusEnum({
    this.order = 0,
    required this.statusDBName,
    required this.statusAr,
    required this.statusEn,
    required this.statusColor,
    this.percent = 1,
  });

  TaskAndSubmissionStatusEnum copyWith(
      {int? order, String? statusDBName, String? statusAr, String? statusEn, Color? statusColor, double? percent}) {
    return TaskAndSubmissionStatusEnum(
      order: order ?? this.order,
      statusDBName: statusDBName ?? this.statusDBName,
      statusAr: statusAr ?? this.statusAr,
      statusEn: statusEn ?? this.statusEn,
      statusColor: statusColor ?? this.statusColor,
      percent: percent ?? this.percent,
    );
  }

  static const TaskAndSubmissionStatusEnum active =
      TaskAndSubmissionStatusEnum(order: 1, statusDBName: 'active', statusAr: 'جديد', statusEn: 'Active', statusColor: Colors.green);

  static const TaskAndSubmissionStatusEnum notActive = TaskAndSubmissionStatusEnum(
      order: 0, statusDBName: 'notActive', statusAr: 'غير مفعل', statusEn: 'Not Active', statusColor: Colors.grey);

  static const TaskAndSubmissionStatusEnum canceled =
      TaskAndSubmissionStatusEnum(order: 0, statusDBName: 'canceled', statusAr: 'ملغي', statusEn: 'Canceled', statusColor: Colors.red);

  static const TaskAndSubmissionStatusEnum inProgress =
      TaskAndSubmissionStatusEnum(order: 2, statusDBName: 'inProgress', statusAr: 'جار', statusEn: 'In Progress', statusColor: Colors.blue);

  static const TaskAndSubmissionStatusEnum completed = TaskAndSubmissionStatusEnum(
      order: 3, statusDBName: 'completed', statusAr: 'منتهي', statusEn: 'Completed', statusColor: Colors.redAccent);

  static const TaskAndSubmissionStatusEnum evaluated = TaskAndSubmissionStatusEnum(
      order: 4, statusDBName: 'evaluated', statusAr: 'تم التقييم', statusEn: 'Evaluated', statusColor: Colors.amber);

  static const TaskAndSubmissionStatusEnum undefined = TaskAndSubmissionStatusEnum(
      order: 0, statusDBName: 'undefined', statusAr: 'غير معرف', statusEn: 'Undefined', statusColor: Colors.grey);

  static List<TaskAndSubmissionStatusEnum> getAllTaskStatuses() {
    return [active, inProgress, completed, evaluated, notActive, canceled];
  }

  static TaskAndSubmissionStatusEnum getStatus(String? status) {
    switch (status) {
      case 'active':
        return active;
      case 'notActive':
        return notActive;
      case 'canceled':
        return canceled;
      case 'inProgress':
        return inProgress;
      case 'completed':
        return completed;
      case 'evaluated':
        return evaluated;
      default:
        return undefined;
    }
  }
}
