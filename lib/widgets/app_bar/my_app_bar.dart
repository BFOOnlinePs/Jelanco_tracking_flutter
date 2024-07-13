import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final List<Widget>? actions;

  const MyAppBar({this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      centerTitle: true,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: ColorsConstants.myLinearGradient
        ),
      ),
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: appGradientColors,
      //   ),
      // ),
    );
  }
}