import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_dashboard_widgets/navigateWidget.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_management_modules/permissions_management_screen.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/role_permissions_management_screen.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_permissions_management_screen.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class PermissionsDashboardScreen extends StatelessWidget {
  const PermissionsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'إدارة الصلاحيات والأدوار'),
      body: MyScreen(
        child: Column(
          children: [
            // Text('إدارة الصلاحيات'),
            Expanded(
              child: ListView(
                children: const [
                  NavigateTextWidget(
                    title: 'إدارة الصلاحيات',
                    description: 'إضافة وتعديل الصلاحيات المتاحة في النظام.',
                    targetScreen: PermissionsManagementScreen(),
                    icon: Icons.security,
                  ),
                  MyVerticalSpacer(),
                  NavigateTextWidget(
                    title: 'إدارة صلاحيات الأدوار',
                    description: "تخصيص الصلاحيات للأدوار المختلفة في النظام.",
                    targetScreen: RolePermissionsManagementScreen(),
                    icon: Icons.group,
                  ),
                  MyVerticalSpacer(),
                  NavigateTextWidget(
                    title: 'إدارة صلاحيات المستخدمين',
                    description: "تعديل الصلاحيات المرتبطة بالمستخدمين بشكل فردي.",
                    targetScreen: UserPermissionsManagementScreen(),
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
