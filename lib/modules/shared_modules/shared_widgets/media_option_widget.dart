import 'package:flutter/material.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
