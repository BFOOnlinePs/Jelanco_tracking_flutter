import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/options_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/components/my_chip_widget.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_alert_dialog/my_alert_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class RolePermissionsManagementScreen extends StatelessWidget {
  const RolePermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RolePermissionsManagementCubit()
        ..getAllRolesWithPermissions(
          loadingState: GetAllRolesWithPermissionsLoadingState(),
          successState: GetAllRolesWithPermissionsSuccessState(),
          errorState: GetAllRolesWithPermissionsErrorState(),
        )
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
          } else if (state is EditRoleSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: state.editRoleModel?.status == true ? SnackBarStates.success : SnackBarStates.error,
              message: state.editRoleModel?.message,
            );
          } else if (state is DeleteRoleSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates: state.deleteRoleModel?.status == true ? SnackBarStates.success : SnackBarStates.error,
              message: state.deleteRoleModel?.message,
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
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          children: [
                                            OptionsWidget(padding: const EdgeInsets.all(0), menuItems: [
                                              MenuItemModel(
                                                label: 'تعديل',
                                                icon: Icons.edit,
                                                onTap: () {
                                                  TextEditingController controller = TextEditingController(text: role.name);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BlocProvider.value(
                                                        value: rolePermissionsManagementCubit,
                                                        child: MyAlertDialog(
                                                            title: 'تعديل الدور',
                                                            content: MyTextFormField(
                                                              controller: controller,
                                                              onChanged: (value) {
                                                                rolePermissionsManagementCubit.onChangeRoleName(controller, value);
                                                              },
                                                              titleText: 'اسم الدور',
                                                            ),
                                                            confirmText: 'تعديل',
                                                            cancelText: 'اغلاق',
                                                            onConfirm: controller.text.isEmpty
                                                                ? null
                                                                : () {
                                                                    Navigator.of(context).pop();
                                                                    rolePermissionsManagementCubit.editRole(
                                                                        roleId: role.id!, roleName: controller.text);
                                                                  }),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              MenuItemModel(
                                                label: 'حذف',
                                                icon: Icons.delete,
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return MyAlertDialog(
                                                        title: 'حذف الدور',
                                                        content: Text('هل انت متأكد من انك تريد حذف دور "${role.name}"؟'),
                                                        confirmText: 'حذف',
                                                        cancelText: 'اغلاق',
                                                        onConfirm: () {
                                                          Navigator.of(context).pop();
                                                          rolePermissionsManagementCubit.deleteRole(roleId: role.id!);
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            ]),

                                            const SizedBox(width: 16),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    role.name ?? 'no name',
                                                    style: Theme.of(context).textTheme.bodyLarge,
                                                  ),
                                                  Text(
                                                    'عدد الصلاحيات: ${role.permissions!.length}',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Trailing widget
                                            // Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                                          ],
                                        ),
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
                floatingActionButton: MyFloatingActionButton(
                  icon: Icons.add,
                  labelText: 'إضافة دور جديد',
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider.value(
                        value: rolePermissionsManagementCubit,
                        child: BlocConsumer<RolePermissionsManagementCubit, RolePermissionsManagementStates>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return MyAlertDialog(
                              title: 'إضافة دور جديد',
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('ادخل اسم الدور المراد اضافته'),
                                  MyTextFormField(
                                    labelText: 'اسم الدور',
                                    controller: controller,
                                    onChanged: (value) {
                                      rolePermissionsManagementCubit.onChangeRoleName(controller, value);
                                    },
                                  ),
                                ],
                              ),
                              confirmText: 'إضافة',
                              cancelText: 'إلغاء',
                              onConfirm: controller.text.isEmpty
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                      rolePermissionsManagementCubit.addRole(roleName: controller.text);
                                    },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              state is AssignPermissionsToRoleLoadingState ||
                      state is AddRoleLoadingState ||
                      state is EditRoleLoadingState ||
                      state is DeleteRoleLoadingState
                  ? const LoaderWithDisable()
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
