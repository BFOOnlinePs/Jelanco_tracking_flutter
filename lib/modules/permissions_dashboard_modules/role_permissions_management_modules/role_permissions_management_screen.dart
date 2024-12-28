import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/components/my_chip_widget.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class RolePermissionsManagementScreen extends StatelessWidget {
  const RolePermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolePermissionsManagementCubit()
        ..getAllRolesWithPermissions()
        ..getAllPermissions(
          loadingState: GetAllPermissionsLoadingState(),
          successState: GetAllPermissionsSuccessState(),
          errorState: GetAllPermissionsErrorState(),
        ),
      child: BlocConsumer<RolePermissionsManagementCubit, RolePermissionsManagementStates>(
        listener: (context, state) {
          if (state is AssignPermissionsToRoleSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates:
                  state.assignPermissionsToRoleStatusMessageModel?.status == true ? SnackBarStates.success : SnackBarStates.error,
              message: state.assignPermissionsToRoleStatusMessageModel?.message,
            );
          }
        },
        builder: (context, state) {
          RolePermissionsManagementCubit rolePermissionsManagementCubit = RolePermissionsManagementCubit.get(context);
          return Stack(
            children: [
              Scaffold(
                appBar: const MyAppBar(title: 'إدارة صلاحيات الأدوار'),
                body: rolePermissionsManagementCubit.getAllRolesWithPermissionsModel == null ||
                        rolePermissionsManagementCubit.allPermissionsList == null
                    ? const Center(child: MyLoader())
                    : MyScreen(
                        child: Column(children: [
                          Text(
                              'في هذه الشاشة، يمكنك تخصيص الصلاحيات للأدوار المختلفة في النظام. حدد الصلاحيات التي يجب أن تتاح لكل دور لضمان التحكم الدقيق في الوصول إلى الميزات المختلفة.'),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ExpansionPanelList(
                                animationDuration: const Duration(milliseconds: 1500),
                                expandedHeaderPadding: const EdgeInsets.all(0),
                                expansionCallback: (int index, bool isExpanded) {
                                  rolePermissionsManagementCubit.setExpandedIndex(index);
                                },
                                children:
                                    rolePermissionsManagementCubit.getAllRolesWithPermissionsModel!.roles!.map<ExpansionPanel>((role) {
                                  return ExpansionPanel(
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return ListTile(
                                        title: Text(role.name ?? 'no name'),
                                        subtitle: Text('عدد الصلاحيات: ${role.permissions!.length}'),
                                      );
                                    },
                                    canTapOnHeader: true,
                                    body: Column(
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: rolePermissionsManagementCubit.allPermissionsList!.map<Widget>((permission) {
                                            bool isSelected =
                                                rolePermissionsManagementCubit.selectedRolePermissionsIds.contains(permission.id!);
                                            return MyChipWidget(
                                              label: permission.name ?? 'No name',
                                              isSelected: isSelected,
                                              onTap: () {
                                                rolePermissionsManagementCubit.addRemoveSelectedRolePermissionsIds(
                                                    permissionId: permission.id!);
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        MyElevatedButton(
                                          onPressed: () {
                                            rolePermissionsManagementCubit.assignPermissionsToRole(
                                              roleId: role.id!,
                                              selectedRolePermissionsIds: rolePermissionsManagementCubit.selectedRolePermissionsIds,
                                            );
                                          },
                                          buttonText: 'تحديث',
                                          isWidthFull: true,
                                          margin: const EdgeInsets.symmetric(vertical: 16),
                                        )
                                      ],
                                    ),
                                    isExpanded: rolePermissionsManagementCubit.expandedIndex ==
                                        rolePermissionsManagementCubit.getAllRolesWithPermissionsModel!.roles!.indexOf(role),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ]),
                      ),
              ),
              state is AssignPermissionsToRoleLoadingState ? const LoaderWithDisable() : Container(),
            ],
          );
        },
      ),
    );
  }
}
