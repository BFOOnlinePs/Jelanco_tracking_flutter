import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediaOptionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function? onTap;

  const MediaOptionWidget({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
