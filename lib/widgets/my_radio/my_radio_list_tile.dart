import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final String? title;
  final T? groupValue;
  final Function(T?)? onChanged;

  const MyRadioListTile({
    required this.value,
    this.title,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          horizontalTitleGap: -4,
        ),
      ),
      child: Container(
        child: RadioListTile<T>(
          value: value,
          title: Text(
            title ?? '',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          dense: true,
          // activeColor: ColorsConstants.primaryColor,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
