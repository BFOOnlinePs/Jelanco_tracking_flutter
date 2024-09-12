import 'package:flutter/material.dart';

class MyCheckBoxListTile extends StatelessWidget {
  final bool? value;
  final String? title;
  final Function(bool?)? onChanged;
  final Widget? subtitle;

  const MyCheckBoxListTile({super.key, 
    required this.value,
    this.title,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: Text(
        title ?? '',
      ),
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      // contentPadding: EdgeInsets.zero, // Remove the padding
      subtitle: subtitle,
    );
  }
}
