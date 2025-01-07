import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/check_box_user_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class ManagersEmployeesTapBody extends StatelessWidget {
  final bool isManagersTab;
  final int userId; // the user we checked for
  final String userName;
  final ManagersAndEmployeesOfUserCubit cubit;

  const ManagersEmployeesTapBody(
      {super.key, required this.isManagersTab, required this.cubit, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   '${isManagersTab ? 'تحديد الاشخاص الذين لهم صلاحية الوصول وادارة سجلات عمل الموظف ${userName}' : 'تحديد الأشخاص الذين يدير ${userName} سجلات عملهم ولديه صلاحية الوصول إليها'}',
        //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //   textAlign: TextAlign.center,
        // ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: isManagersTab ? 'تحديد الاشخاص الذين لهم صلاحية الوصول وادارة سجلات عمل الموظف ' : 'تحديد الأشخاص الذين يدير ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: userName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              TextSpan(
                text: isManagersTab ? '' : ' سجلات عملهم ولديه صلاحية الوصول إليها',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: MyTextFormField(
            onChanged: (query) {
              cubit.usersSearch(query, isManagersTab);
            },
            labelText: 'بحث عن ${isManagersTab ? 'مسؤول' : 'موظف'}',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: isManagersTab ? cubit.filteredManagers.length : cubit.filteredEmployees.length,
            itemBuilder: (context, index) {
              UserModel user = isManagersTab ? cubit.filteredManagers[index] : cubit.filteredEmployees[index];

              // print('selected: ${isManagersTab
              //     ? '${!cubit.selectedEmployees.any((emp) => emp.id == user.id)}' '${!cubit.initialSelectedEmployees.any((emp) =>
              // emp.id == user.id)}'
              //     : '${!cubit.selectedManagers.any((man) => man.id == user.id)}' '${!cubit.initialSelectedManagers.any((man) =>
              // man.id == user.id)}'
              // })');
              return CheckBoxUserWidget(
                user: user,
                value: isManagersTab
                    ? cubit.selectedManagers.contains(cubit.filteredManagers[index])
                    : cubit.selectedEmployees.contains(cubit.filteredEmployees[index]),
                onChanged: (bool? value) {
                  cubit.toggleUserSelection(user, isManagersTab);
                },
                enabled: isManagersTab
                    ? !cubit.selectedEmployees.any((emp) => emp.id == user.id) &&
                        !cubit.initialSelectedEmployees.any((emp) => emp.id == user.id)
                    : !cubit.selectedManagers.any((man) => man.id == user.id) &&
                        !cubit.initialSelectedManagers.any((man) => man.id == user.id),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: MyElevatedButton(
            onPressed: () {
              if (isManagersTab) {
                cubit.assignEmployeeForManagers(employeeId: userId, managersUsers: cubit.selectedManagers);
              } else {
                cubit.addEditManagerEmployees(managerId: userId, employeesUsers: cubit.selectedEmployees);
              }
            },
            buttonText: isManagersTab ? 'تحديث المسؤولين' : 'تحديث الموظفين',
          ),
        )
      ],
    );
  }
}
