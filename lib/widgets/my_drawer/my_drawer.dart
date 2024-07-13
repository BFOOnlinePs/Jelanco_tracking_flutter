import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_screen.dart';

import 'drawer_item.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              gradient: ColorsConstants.myLinearGradient,
            ),
            child: const Column(
              children: [
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                // ),
                SizedBox(height: 26),
                Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'email@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerItem(
                  icon: Icons.add_task,
                  text: 'Add Task',
                  onTap: () {
                    NavigationServices.navigateTo(
                      context,
                      AddTaskScreen(),
                    );
                  },
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10),
                Text('Version 1.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
