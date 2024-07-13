import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyErrorFieldText extends StatelessWidget {
  final String text;

  const MyErrorFieldText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 16),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
        ),
      ),
    );
  }
}
