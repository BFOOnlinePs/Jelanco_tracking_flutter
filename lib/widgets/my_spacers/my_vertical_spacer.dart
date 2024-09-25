import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyVerticalSpacer extends StatelessWidget {
  final double? height;
  final bool isEndOfScreen;

  const MyVerticalSpacer({
    super.key,
    this.height = 10,
    this.isEndOfScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: isEndOfScreen ? 60 : height?.h);
  }
}
