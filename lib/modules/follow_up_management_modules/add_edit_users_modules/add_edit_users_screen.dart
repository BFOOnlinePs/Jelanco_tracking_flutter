import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_cubit.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class AddEditUsersScreen extends StatefulWidget {
  final UserModel? selectedUser;

  const AddEditUsersScreen({super.key, this.selectedUser});

  @override
  _AddEditUsersScreenState createState() => _AddEditUsersScreenState();
}

class _AddEditUsersScreenState extends State<AddEditUsersScreen> {
  late AddEditUsersCubit addEditUsersCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditUsersCubit()
        ..initValues(widget.selectedUser)
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(),
        ),
      child: BlocConsumer<AddEditUsersCubit, AddEditUsersStates>(
        listener: (context, state) {
          if (state is GetAllUsersSuccessState) {
            addEditUsersCubit.allUsers = addEditUsersCubit.getAllUsersModel?.users ?? [];
            addEditUsersCubit.filteredAllUsers = addEditUsersCubit.allUsers; // Initialize with all users
          } else if (state is AddEditManagerEmployeesSuccessState) {
            if (state.addEditManagerEmployeesModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.addEditManagerEmployeesModel.message,
              );
              NavigationServices.back(context, addEditUsersCubit.employeesUsers);
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.addEditManagerEmployeesModel.message,
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
                children: [
                  // Dropdown for selecting a user
                  Text(
                    'المسؤول:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<UserModel>(
                    // value: selectedUser,
                    hint: Text('إختر موظف'),
                    items: addEditUsersCubit.allUsers.map((UserModel user) {
                      return DropdownMenuItem<UserModel>(
                        value: user,
                        child: Text(user.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (UserModel? newValue) {
                      setState(() {
                        addEditUsersCubit.managerUser = newValue; // Update the selected user
                      });
                    },
                    validator: (value) => value == null ? 'الرجاء إختيار موظف' : null,
                  ),
                  SizedBox(height: 20),
                  // Search for selecting multiple users
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
                        return CheckboxListTile(
                          title: Text(addEditUsersCubit.filteredAllUsers[index].name ?? 'user name'),
                          value: addEditUsersCubit.employeesUsers
                              .contains(addEditUsersCubit.filteredAllUsers[index]),
                          onChanged: (bool? value) {
                            addEditUsersCubit.toggleEmployeeSelection(addEditUsersCubit.filteredAllUsers[index]);
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
