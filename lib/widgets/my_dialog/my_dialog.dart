import 'package:flutter/material.dart';

import '../my_buttons/my_elevated_button.dart';

void myDialog(BuildContext context, {required String title, required Widget content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          child: content,
        ),
      );
    },
  );
}