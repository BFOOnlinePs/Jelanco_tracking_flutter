import 'package:flutter/cupertino.dart';

class ScrollUtils {
  static void scrollPosition({
    required ScrollController scrollController,
    double? offset,
  }) {
    print('scroll');
    scrollController.animateTo(
      offset ?? 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
