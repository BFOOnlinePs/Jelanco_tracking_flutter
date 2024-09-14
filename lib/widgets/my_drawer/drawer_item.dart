import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 22.w,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 14.sp),
      ),
      onTap: onTap,
    );
  }
}
