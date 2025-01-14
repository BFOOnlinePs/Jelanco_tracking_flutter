import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const MyAppBar({super.key, this.title, this.leading, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: TextStyle(color: Colors.white, fontSize: 20.sp),
      ),
      leading: leading,
      iconTheme: IconThemeData(color: Colors.white, size: 20.sp),
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
        decoration:
            const BoxDecoration(gradient: ColorsConstants.myLinearGradient),
      ),

      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: appGradientColors,
      //   ),
      // ),
    );
  }
}
