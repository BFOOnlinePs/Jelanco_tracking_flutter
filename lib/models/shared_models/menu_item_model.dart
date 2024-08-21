import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  MenuItemModel({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
