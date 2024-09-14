import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyVerticalSpacer extends StatelessWidget {
  final double? height;

  const MyVerticalSpacer({
    super.key,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height?.h);
  }
}
