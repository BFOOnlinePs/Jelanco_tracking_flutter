import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/add_user_screen.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'إدارة الموظفين',
      ),
      body: MyScreen(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MyScreenTitleWidget(title: 'إدارة الموظفين'),
            ],
          ),
        ),
      ),
      floatingActionButton: MyFloatingActionButton(
          icon: Icons.add,
          labelText: 'إضافة موظف',
          onPressed: () {
            NavigationServices.navigateTo(context, const AddUserScreen());
          }),
    );
  }
}
