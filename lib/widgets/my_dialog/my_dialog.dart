import 'package:flutter/material.dart';

void myDialog(BuildContext context, {required String title, required Widget content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: content,
        ),
      );
    },
  );
}