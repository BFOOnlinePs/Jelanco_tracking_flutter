import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';

class MyTabBar extends StatelessWidget {
  final int length;
  final List<Widget> tabs;
  final Widget expandedChild;
  const MyTabBar({super.key, required this.length, required this.tabs, required this.expandedChild});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: Column(
        children: [
          TabBar(
            labelPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: ColorsConstants.primaryColor,
            labelColor: ColorsConstants.primaryColor,
            unselectedLabelColor: ColorsConstants.primaryColor.withOpacity(0.8),
            // indicator: BoxDecoration(
            //   color: ColorsConstants.primaryColor.withOpacity(0.1),
            // ),
            labelStyle: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
            dividerHeight: 0.5,
            tabs: tabs,
          ),
          Expanded(child: expandedChild)
        ],
      ),


    );
  }
}
