import 'package:flutter/cupertino.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';

class MyScreen extends StatelessWidget {
  final Widget child;

  const MyScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SharedSize.screenHorizontalPadding,
          vertical: SharedSize.screenVerticalPadding,
        ),
        child: child,
      ),
    );
  }
}
