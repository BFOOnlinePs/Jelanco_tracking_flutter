import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';

class RolePermissionsManagementScreen extends StatelessWidget {
  const RolePermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolePermissionsManagementCubit()..getAllRolesWithPermissions(),
      child: BlocConsumer<RolePermissionsManagementCubit, RolePermissionsManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          RolePermissionsManagementCubit rolePermissionsManagementCubit = RolePermissionsManagementCubit.get(context);
          return Scaffold(
            appBar: MyAppBar(title: 'إدارة صلاحيات الأدوار'),
            body: rolePermissionsManagementCubit.getAllRolesWithPermissionsModel == null
                ? const Center(child: MyLoader())
                : MyScreen(
                    child: Column(children: [
                    Text(
                        'في هذه الشاشة، يمكنك تخصيص الصلاحيات للأدوار المختلفة في النظام. حدد الصلاحيات التي يجب أن تتاح لكل دور لضمان التحكم الدقيق في الوصول إلى الميزات المختلفة.'),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            rolePermissionsManagementCubit.setExpandedIndex(index);
                          },
                          children: rolePermissionsManagementCubit.getAllRolesWithPermissionsModel!.roles!.map<ExpansionPanel>((role) {
                            return ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(title: Text(role.name ?? 'no name'));
                              },
                              canTapOnHeader: true,
                              body: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: role.permissions!.map<Widget>((permission) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle the click event
                                      print('Clicked on: ${permission.name}');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade300),
                                      ),
                                      child: Text(
                                        permission.name ?? 'No name',
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              isExpanded: rolePermissionsManagementCubit.expandedIndex ==
                                  rolePermissionsManagementCubit.getAllRolesWithPermissionsModel!.roles!.indexOf(role),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ])),
          );
        },
      ),
    );
  }
}
