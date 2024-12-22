import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/check_box_user_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class ManagersEmployeesTapBody extends StatelessWidget {
  final bool isManagersTab;
  final int userId;
  final ManagersAndEmployeesOfUserCubit cubit;

  const ManagersEmployeesTapBody({super.key, required this.isManagersTab, required this.cubit, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: MyTextFormField(
            onChanged: (query) {
              cubit.usersSearch(query, isManagersTab);
            },
            labelText: 'بحث عن ${isManagersTab ? 'مدير' : 'موظف'}',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: isManagersTab ? cubit.filteredManagers.length : cubit.filteredEmployees.length,
            itemBuilder: (context, index) {
              UserModel user = isManagersTab ? cubit.filteredManagers[index] : cubit.filteredEmployees[index];
              // Exclude the manager user from the list by its id
              // if (cubit.managerUser != null &&
              //     cubit.filteredAllUsers[index].id == cubit.managerUser!.id) {
              //   return const SizedBox.shrink();
              // }
              return CheckBoxUserWidget(
                user: user,
                value: isManagersTab
                    ? cubit.selectedManagers.contains(cubit.filteredManagers[index])
                    : cubit.selectedEmployees.contains(cubit.filteredEmployees[index]),
                onChanged: (bool? value) {
                  cubit.toggleUserSelection(user, isManagersTab);
                },
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
            buttonText: isManagersTab ? 'تحديث المدراء' : 'تحديث الموظفين',
          ),
        )
      ],
    );
  }
}
