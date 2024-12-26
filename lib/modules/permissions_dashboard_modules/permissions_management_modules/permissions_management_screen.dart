import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_dashboard_widgets/permission_widget.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_management_modules/cubit/permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_management_modules/cubit/permissions_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_alert_dialog/my_alert_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class PermissionsManagementScreen extends StatelessWidget {
  const PermissionsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsManagementCubit()
        ..getAllPermissions(
          loadingState: GetAllPermissionsLoadingState(),
          successState: GetAllPermissionsSuccessState(),
          errorState: GetAllPermissionsErrorState(),
        ),
      child: BlocConsumer<PermissionsManagementCubit, PermissionsManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          PermissionsManagementCubit permissionsManagementCubit = PermissionsManagementCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(title: 'ادارة الصلاحيات'),
            body: MyScreen(
              child: Column(
                children: [
                  const Text(
                      'في هذه الشاشة، يمكنك عرض وتعديل الصلاحيات المتاحة للمستخدمين والأدوار المختلفة في النظام. قم بتحديد الصلاحيات التي يمكن منحها أو إلغاءها بناءً على متطلبات العمل.'),
                  Expanded(
                    child: permissionsManagementCubit.allPermissionsList == null
                        ? const Center(child: MyLoader())
                        : ListView.builder(
                            itemCount: permissionsManagementCubit.allPermissionsList!.length,
                            itemBuilder: (context, index) => Container(
                              margin: index == permissionsManagementCubit.allPermissionsList!.length - 1
                                  ? const EdgeInsets.only(bottom: 70)
                                  : null,
                              child: SystemPermissionWidget(
                                permissionText: permissionsManagementCubit.allPermissionsList![index].name ?? '',
                                onEditTap: () {
                                  TextEditingController controller =
                                      TextEditingController(text: permissionsManagementCubit.allPermissionsList![index].name);

                                  showDialog(
                                    context: context,
                                    builder: (context) => BlocProvider.value(
                                      value: permissionsManagementCubit,
                                      child: BlocConsumer<PermissionsManagementCubit, PermissionsManagementStates>(
                                        listener: (context, state) {},
                                        builder: (context, state) {
                                          return MyAlertDialog(
                                            title: 'تعديل الصلاحية',
                                            content: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('قم بتعديل اسم الصلاحية'),
                                                MyTextFormField(
                                                  labelText: 'اسم الصلاحية',
                                                  controller: controller,
                                                  onChanged: (value) {
                                                    permissionsManagementCubit.onChangePermissionName(controller, value);
                                                  },
                                                ),
                                              ],
                                            ),
                                            confirmText: 'تعديل',
                                            cancelText: 'إلغاء',
                                            onConfirm: controller.text.isEmpty
                                                ? null
                                                : () {
                                                    permissionsManagementCubit.updatePermission(
                                                      permissionId: permissionsManagementCubit.allPermissionsList![index].id!,
                                                      permissionName: controller.text,
                                                    );
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
                          ),
                  ),
                ],
              ),
            ),
            floatingActionButton: MyFloatingActionButton(
              labelText: 'اضافة صلاحية جديدة',
              icon: Icons.add,
              onPressed: () {
                TextEditingController controller = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: permissionsManagementCubit,
                    child: BlocConsumer<PermissionsManagementCubit, PermissionsManagementStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return MyAlertDialog(
                          title: 'إضافة صلاحية',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ادخل اسم الصلاحية المراد اضافتها'),
                              MyTextFormField(
                                labelText: 'اسم الصلاحية',
                                controller: controller,
                                onChanged: (value) {
                                  permissionsManagementCubit.onChangePermissionName(controller, value);
                                },
                              ),
                            ],
                          ),
                          confirmText: 'إضافة',
                          cancelText: 'إلغاء',
                          onConfirm: controller.text.isEmpty
                              ? null
                              : () {
                                  permissionsManagementCubit.addPermission(
                                    permissionName: controller.text,
                                  );
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
          );
        },
      ),
    );
  }
}
