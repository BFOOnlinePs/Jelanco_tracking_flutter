import 'package:flutter/material.dart';

class MyErrorFieldText extends StatelessWidget {
  final String text;

  const MyErrorFieldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 6),
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
