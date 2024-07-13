import 'package:flutter/material.dart';

enum SnackBarStates { success, error, warning }

class SnackbarHelper {

  static void showSnackbar({
    required BuildContext context,
    String? message,
    required SnackBarStates snackBarStates,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
        backgroundColor: chooseSnackBarColor(snackBarStates),
        duration: duration ?? const Duration(milliseconds: 4000),
        // showCloseIcon: true,
        // closeIconColor: Colors.white,
      ),
    );
  }

  static Color chooseSnackBarColor(SnackBarStates snackBarState) {
    Color snackBarColor;
    switch (snackBarState) {
      case SnackBarStates.success:
        snackBarColor = Colors.green;
        break;
      case SnackBarStates.error:
        snackBarColor = Colors.red;
        break;
      case SnackBarStates.warning:
        snackBarColor = Colors.amber;
        break;
    }
    return snackBarColor;
  }
}
