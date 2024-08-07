import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const MyAppBar({this.title, this.actions});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        // style: TextStyle(color: Colors.white),
        style: TextStyle(color: Colors.white),
      ),
      // iconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
      centerTitle: true,
      actions: actions,
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(4.0), // Here you can specify the height of the line
      //   child: Container(
      //     color: Colors.grey, // The color of the line
      //     height: 0.5, // The height of the line
      //   ),
      // ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: ColorsConstants.myLinearGradient),
      ),

      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: appGradientColors,
      //   ),
      // ),
    );
  }
}
