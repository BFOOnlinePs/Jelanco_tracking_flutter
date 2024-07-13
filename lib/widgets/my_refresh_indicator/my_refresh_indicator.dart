import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';

class MyRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  MyRefreshIndicator({
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      backgroundColor: Colors.white,
      color: ColorsConstants.primaryColor,
      displacement: 20,
      strokeWidth: 2,
      onRefresh: onRefresh,
      child: child,
    );
  }
}