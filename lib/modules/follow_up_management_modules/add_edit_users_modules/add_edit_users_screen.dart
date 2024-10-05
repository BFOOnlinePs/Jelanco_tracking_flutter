import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_cubit.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class AddEditUsersScreen extends StatefulWidget {
  final int? selectedUserId;

  const AddEditUsersScreen({super.key, this.selectedUserId});

  @override
  _AddEditUsersScreenState createState() => _AddEditUsersScreenState();
}

class _AddEditUsersScreenState extends State<AddEditUsersScreen> {
  late AddEditUsersCubit addEditUsersCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditUsersCubit()
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(),
        ).then((_) {
          // addEditUsersCubit.initValues(widget.selectedUserId);
        }),
      child: BlocConsumer<AddEditUsersCubit, AddEditUsersStates>(
        listener: (context, state) {
          if (state is GetAllUsersSuccessState) {
            addEditUsersCubit.allUsers = addEditUsersCubit.getAllUsersModel?.users ?? [];
            addEditUsersCubit.filteredAllUsers = addEditUsersCubit.allUsers; // Initialize with all users
            print('when GetAllUsersSuccessState');
            print('allUsers: ${addEditUsersCubit.allUsers.map((user) => user.toMap()).toList()}');

            addEditUsersCubit.initValues(widget.selectedUserId);
          } else if (state is AddEditManagerEmployeesSuccessState) {
            if (state.addEditManagerEmployeesModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.addEditManagerEmployeesModel.message,
              );
              // return the new selected manager
              NavigationServices.back(
                  context, ManagerAction(managerModel: addEditUsersCubit.managerUser)); // isRemove = false
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.addEditManagerEmployeesModel.message,
              );
            }
          } else if (state is DeleteManagerSuccessState) {
            if (state.deleteManagerModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.deleteManagerModel.message,
              );
              // return the new selected manager
              NavigationServices.back(
                  context, ManagerAction(managerModel: addEditUsersCubit.managerUser, isRemove: true));
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.deleteManagerModel.message,
              );
            }
          }
        },
        builder: (context, state) {
          addEditUsersCubit = AddEditUsersCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('إضافة / تعديل الموظفين'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for selecting a user
                  Row(
                    children: [
                      const Text(
                        'المسؤول:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      MyTextButtonNoBorder(
                          onPressed: () {
                            addEditUsersCubit.deleteManager();
                          },
                          child: Text('حذف المسؤول'))
                    ],
                  ),
                  DropdownButtonFormField<UserModel>(
                    value: addEditUsersCubit.managerUser,
                    hint: Text('إختر موظف'),
                    items: addEditUsersCubit.allUsers.map((UserModel user) {
                      return DropdownMenuItem<UserModel>(
                        value: user,
                        child: Text(user.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (UserModel? newValue) {
                      // setState(() {
                      //   addEditUsersCubit.managerUser = newValue; // Update the selected user
                      // });
                      addEditUsersCubit.selectManager(newValue);
                    },
                    validator: (value) => value == null ? 'الرجاء إختيار موظف' : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'تحديد الموظفين للمتابعة:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'بحث عن موظفين',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: addEditUsersCubit.usersSearch,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: addEditUsersCubit.filteredAllUsers.length,
                      itemBuilder: (context, index) {
                        // Exclude the manager user from the list by its id
                        if (addEditUsersCubit.managerUser != null &&
                            addEditUsersCubit.filteredAllUsers[index].id ==
                                addEditUsersCubit.managerUser!.id) {
                          return const SizedBox.shrink();
                        }
                        return CheckboxListTile(
                          title: Text(addEditUsersCubit.filteredAllUsers[index].name ?? 'user name'),
                          value: addEditUsersCubit.employeesUsers
                              .contains(addEditUsersCubit.filteredAllUsers[index]),
                          onChanged: (bool? value) {
                            addEditUsersCubit
                                .toggleEmployeeSelection(addEditUsersCubit.filteredAllUsers[index]);
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addEditUsersCubit.addEditManagerEmployees();
                    },
                    child: Text('حفظ'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
