import 'package:flutter/material.dart';

class NotificationsFilterEnum {
  final int code; // 2: All, 1: Read, 0: Unread
  final String name;
  final IconData icon;

  const NotificationsFilterEnum({
    required this.code,
    required this.name,
    required this.icon,
  });

  static const NotificationsFilterEnum all = NotificationsFilterEnum(
    code: 2,
    name: 'الكل',
    icon: Icons.notifications_active_outlined,
  );
  static const NotificationsFilterEnum read = NotificationsFilterEnum(
    code: 1,
    name: 'المقروءة',
    icon: Icons.done_all,
  );
  static const NotificationsFilterEnum unread = NotificationsFilterEnum(
    code: 0,
    name: 'غير المقروءة',
    icon: Icons.mark_email_unread_outlined,
  );

  static const NotificationsFilterEnum undefined = NotificationsFilterEnum(
    code: 3,
    name: 'غير معرف',
    icon: Icons.mark_email_unread_outlined,
  );

  static List<NotificationsFilterEnum> getAllStatuses() {
    return [all, read, unread];
  }

  static NotificationsFilterEnum getStatus(int? code) {
    switch (code) {
      case 2:
        return all;
      case 1:
        return read;
      case 0:
        return unread;
      default:
        return undefined;
    }
  }
}
