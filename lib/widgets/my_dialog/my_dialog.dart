import 'package:flutter/material.dart';

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