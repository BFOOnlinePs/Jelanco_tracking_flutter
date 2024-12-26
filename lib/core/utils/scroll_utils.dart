import 'package:flutter/cupertino.dart';

class ScrollUtils {
  static void scrollPosition({
    required ScrollController scrollController,
    double? offset,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    print('scroll');
    scrollController.animateTo(
      offset ?? 0,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }
}
