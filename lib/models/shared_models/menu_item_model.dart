import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  MenuItemModel({
    required this.icon,
    this.iconColor =  Colors.black,
    required this.label,
    required this.onTap,
  });
}
