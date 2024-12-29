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
import 'package:jelanco_tracking_system/widgets/my_alert_dialog/my_alert_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_dividers/my_horizontal_divider.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

// this screen has 2 Cubits
// 1- UserRolesAndPermissionsManagementCubit
// 2- UserPermissionsManagementCubit (from previous screen, without consumer)
class UserRolesAndPermissionsManagementScreen extends StatelessWidget {
  final UserModel user;
  final UserPermissionsManagementCubit userPermissionsManagementCubit;

  UserRolesAndPermissionsManagementScreen({super.key, required this.user, required this.userPermissionsManagementCubit});

  late UserRolesAndPermissionsManagementCubit userRolesAndPermissionsManagementCubit;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: BlocProvider(
        create: (context) => UserRolesAndPermissionsManagementCubit()
          ..init(
              userId: user.id!,
              allPermissions: userPermissionsManagementCubit.allPermissionsList,
              getAllRolesWithPermissionsModel: userPermissionsManagementCubit.getAllRolesWithPermissionsModel),
        child: BlocConsumer<UserRolesAndPermissionsManagementCubit, UserRolesAndPermissionsManagementStates>(
          listener: (context, state) {
            if (state is AssignRolesToUserSuccessState) {
              SnackbarHelper.showSnackbar(
                  context: context,
                  snackBarStates: state.assignRolesToUserModel.status == true ? SnackBarStates.success : SnackBarStates.error,
                  message: state.assignRolesToUserModel.message);
            } else if (state is AssignPermissionsToUserSuccessState) {
              SnackbarHelper.showSnackbar(
                  context: context,
                  snackBarStates: state.assignPermissionsToUserModel.status == true ? SnackBarStates.success : SnackBarStates.error,
                  message: state.assignPermissionsToUserModel.message);
            }
          },
          builder: (context, state) {
            userRolesAndPermissionsManagementCubit = UserRolesAndPermissionsManagementCubit.get(context);
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
                                Text('لعرض صلاحيات الدور، اضغط عليه ضغطة مطولة.', style: Theme.of(context).textTheme.bodySmall),
                                SizedBox(
                                  height: 4,
                                ),
                                Wrap(
                                  // spacing: 8,
                                  // runSpacing: 8,
                                  children: userPermissionsManagementCubit.getAllRolesWithPermissionsModel!.roles!.map<Widget>((role) {
                                    bool isSelected = userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel?.roleIds
                                            ?.any((roleId) => roleId == role.id) ??
                                        false;
                                    return Container(
                                      margin: const EdgeInsets.all(4),
                                      child: MyChipWidget(
                                        label: role.name,
                                        isSelected: isSelected,
                                        onTap: () {
                                          userRolesAndPermissionsManagementCubit.toggleRoleSelection(role.id!);
                                        },
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => MyAlertDialog(
                                              title: 'صلاحيات ${role.name}',
                                              content: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: List.generate(
                                                  role.permissions!.length,
                                                  (index) => Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${index + 1}.',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.grey[700],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            role.permissions![index].name ?? 'No name',
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              showConfirmButton: false,
                                              cancelText: 'إغلاق',
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                                MyElevatedButton(
                                  buttonText: 'حفظ الأدوار',
                                  onPressed: () {
                                    userRolesAndPermissionsManagementCubit.assignRolesToUser(
                                        userId: user.id!,
                                        roleIds: userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel?.roleIds ?? []);
                                  },
                                  isWidthFull: true,
                                  margin: const EdgeInsets.only(top: 10, bottom: 8),
                                ),
                                MyVerticalSpacer(),
                                Text('الصلاحيات الإضافية', style: Theme.of(context).textTheme.headlineSmall),
                                Wrap(
                                  // spacing: 8,
                                  // runSpacing: 8,
                                  /// move to the cubit, create showed permissions list or hidden permissions list
                                  children: userRolesAndPermissionsManagementCubit.visiblePermissions.map<Widget>((permission) {
                                    bool isSelected = userRolesAndPermissionsManagementCubit
                                            .getUserRoleAndPermissionIdsModel?.directPermissionIds
                                            ?.any((permissionId) => permissionId == permission.id) ??
                                        false;
                                    return Container(
                                      margin: const EdgeInsets.all(4),
                                      child: MyChipWidget(
                                          label: permission.name,
                                          isSelected: isSelected,
                                          onTap: () {
                                            userRolesAndPermissionsManagementCubit.togglePermissionSelection(permission.id!);
                                          }),
                                    );
                                  }).toList(),
                                ),
                                MyElevatedButton(
                                  buttonText: 'حفظ الصلاحيات',
                                  onPressed: () {
                                    userRolesAndPermissionsManagementCubit.assignPermissionsToUser(
                                        userId: user.id!,
                                        permissionIds:
                                            userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel?.directPermissionIds ??
                                                []);
                                  },
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
                userRolesAndPermissionsManagementCubit.getUserRoleAndPermissionIdsModel == null ||
                        state is AssignPermissionsToUserLoadingState ||
                        state is AssignRolesToUserLoadingState
                    ? const LoaderWithDisable()
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
