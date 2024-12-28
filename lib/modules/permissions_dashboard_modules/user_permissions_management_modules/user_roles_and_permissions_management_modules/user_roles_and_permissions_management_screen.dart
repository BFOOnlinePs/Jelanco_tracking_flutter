import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/cubit/user_roles_and_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/cubit/user_roles_and_permissions_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/components/my_chip_widget.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_dividers/my_horizontal_divider.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

// this screen has 2 Cubits
// 1- UserRolesAndPermissionsManagementCubit
// 2- UserPermissionsManagementCubit (from previous screen, without consumer)
class UserRolesAndPermissionsManagementScreen extends StatelessWidget {
  final UserModel user;

  const UserRolesAndPermissionsManagementScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserRolesAndPermissionsManagementCubit()..getUserRoleAndPermissionIds(userId: user.id!),
      child: BlocConsumer<UserRolesAndPermissionsManagementCubit, UserRolesAndPermissionsManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserPermissionsManagementCubit userPermissionsManagementCubit = UserPermissionsManagementCubit.get(context);
          UserRolesAndPermissionsManagementCubit userRolesAndPermissionsManagementCubit =
              UserRolesAndPermissionsManagementCubit.get(context);
          return Stack(
            children: [
              Scaffold(
                appBar: MyAppBar(title: 'صلاحيات المستخدم'),
                body: MyScreen(
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16.0, color: Colors.black),
                          children: [
                            const TextSpan(
                              text: 'من هذه الشاشة، يمكنك تعديل الصلاحيات المرتبطة بالمستخدمين بشكل فردي. قم بتخصيص صلاحيات ',
                            ),
                            TextSpan(
                              text: '${user.name}',
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                              text: ' بناءً على احتياجاته وامتيازاته في النظام.',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const MyHorizontalDivider(topMargin: 10, bottomMargin: 10),
                              Text('الأدوار', style: Theme.of(context).textTheme.headlineSmall),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: userPermissionsManagementCubit.allRolesList!.map<Widget>((role) {
                                  // bool isSelected = userPermissionsManagementCubit.userRolesList!.any((element) => element.id == role.id);
                                  bool isSelected = userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel?.roleIds
                                          ?.any((roleId) => roleId == role.id) ??
                                      false;
                                  return MyChipWidget(
                                      label: role.name,
                                      isSelected: isSelected,
                                      onTap: () {
                                        userRolesAndPermissionsManagementCubit.toggleRoleSelection(role.id!);
                                      });
                                }).toList(),
                              ),
                              MyElevatedButton(
                                buttonText: 'حفظ الأدوار',
                                onPressed: () {},
                                isWidthFull: true,
                                margin: const EdgeInsets.only(top: 10, bottom: 8),
                              ),
                              MyVerticalSpacer(),
                              Text('الصلاحيات', style: Theme.of(context).textTheme.headlineSmall),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: userPermissionsManagementCubit.allPermissionsList!.map<Widget>((permission) {
                                  bool isSelected = userRolesAndPermissionsManagementCubit
                                          .getUserRoleAndPermissionIdsModel?.directPermissionIds
                                          ?.any((permissionId) => permissionId == permission.id) ??
                                      false;
                                  return MyChipWidget(
                                      label: permission.name,
                                      isSelected: isSelected,
                                      onTap: () {
                                        userRolesAndPermissionsManagementCubit.togglePermissionSelection(permission.id!);
                                      });
                                }).toList(),
                              ),
                              MyElevatedButton(
                                buttonText: 'حفظ الصلاحيات',
                                onPressed: () {},
                                isWidthFull: true,
                                margin: const EdgeInsets.only(top: 10, bottom: 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel == null ? const LoaderWithDisable() : Container(),
            ],
          );
        },
      ),
    );
  }
}
