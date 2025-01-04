import 'package:flutter/material.dart';

class UserStatusEnum {
  final String statusDBName; // in database
  final bool isActive;
  final String statusNameAr;
  final String statusNameEn;
  final Color color;

  const UserStatusEnum(
      {required this.statusDBName, required this.statusNameAr, required this.statusNameEn, required this.color, this.isActive = false});

  static const UserStatusEnum active =
      UserStatusEnum(statusDBName: 'active', isActive: true, statusNameAr: 'مفعل', statusNameEn: 'Active', color: Colors.green);
  static const UserStatusEnum inactive =
      UserStatusEnum(statusDBName: 'not_active', isActive: false, statusNameAr: 'غير مفعل', statusNameEn: 'Inactive', color: Colors.red);
  static const UserStatusEnum undefined =
      UserStatusEnum(statusDBName: 'undefined', isActive: false, statusNameAr: 'غير محدد', statusNameEn: 'Undefined', color: Colors.grey);

  static List<UserStatusEnum> getAllStatuses() => [active, inactive];

  static UserStatusEnum getStatus(String? status) {
    switch (status) {
      case 'active':
        return active;
      case 'not_active':
        return inactive;
      default:
        return undefined;
    }
  }
}
