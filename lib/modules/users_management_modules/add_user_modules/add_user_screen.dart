import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/validation_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_multi_selection_drop_down.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddUserScreen extends StatelessWidget {
  final int? userId; // for edit
  const AddUserScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserCubit()
        ..getAllDepartments(
          loadingState: GetAllDepartmentsLoadingState(),
          successState: GetAllDepartmentsSuccessState(),
          errorState: GetAllDepartmentsErrorState(),
        ),
      child: BlocConsumer<AddUserCubit, AddUserStates>(
        listener: (context, state) {
          if (state is AddUserSuccessState) {
            SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: state.addUserModel.status == true ? SnackBarStates.success : SnackBarStates.error,
                message: state.addUserModel.message);
            if (state.addUserModel.status == true) {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
          AddUserCubit addUserCubit = AddUserCubit.get(context);
          return Stack(
            children: [
              Scaffold(
                appBar: const MyAppBar(
                  title: 'إضافة موظف',
                ),
                body: MyScreen(
                  child: Form(
                    key: addUserCubit.formKey,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        MyTextFormField(
                          titleText: 'إسم الموظف',
                          labelText: 'إسم الموظف',
                          keyboardType: TextInputType.name,
                          validator: ValidationUtils.validateUserName,
                          isFieldRequired: true,
                          controller: addUserCubit.nameController,
                        ),
                        MyTextFormField(
                          titleText: 'البريد الإلكتروني',
                          labelText: 'البريد الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          controller: addUserCubit.emailController,
                          validator: ValidationUtils.validateEmail,
                        ),
                        MyTextFormField(
                          titleText: 'رقم الجوال',
                          labelText: 'رقم الجوال',
                          keyboardType: TextInputType.phone,
                          controller: addUserCubit.phoneController,
                          validator: ValidationUtils.validatePhone,
                        ),
                        MyTextFormField(
                          titleText: 'كلمة المرور',
                          labelText: 'كلمة المرور',
                          obscureText: addUserCubit.isVisible,
                          controller: addUserCubit.passwordController,
                          isFieldRequired: true,
                          // icon for show hide
                          suffixIcon: InkWell(
                            onTap: () {
                              addUserCubit.togglePasswordVisibility(passwordVisibilityState: TogglePasswordVisibilityState());
                            },
                            child: Icon(
                              addUserCubit.isVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            return null;
                          },
                        ),
                        MyTextFormField(
                          titleText: 'المسمى الوظيفي',
                          labelText: 'المسمى الوظيفي',
                          controller: addUserCubit.jobTitleController,
                        ),
                        addUserCubit.getDepartmentsModel == null
                            ? Container()
                            : MyMultiSelectDropDown<DepartmentModel>(
                                items: addUserCubit.getDepartmentsModel!.departments!
                                    .map((e) => DropdownItem(label: e.dName ?? 'no dep name', value: e))
                                    .toList(),
                                hint: 'الأقسام',
                                titleText: 'الأقسام',
                                onSelectionChange: (value) {
                                  print(value.length);
                                  addUserCubit.selectedDepartments = value;
                                },
                              ),
                        const MyVerticalSpacer(),
                        SizedBox(
                          width: double.infinity,
                          child: MyElevatedButton(
                            onPressed: () {
                              final validateMessage = addUserCubit.validatePhoneAndEmail();
                              if (validateMessage != null) {
                                SnackbarHelper.showSnackbar(
                                    context: context, snackBarStates: SnackBarStates.error, message: validateMessage);
                              } else {
                                if (addUserCubit.formKey.currentState!.validate()) {
                                  addUserCubit.addNewUser();
                                }
                              }
                            },
                            buttonText: 'إضافة الموظف',
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              state is AddUserLoadingState ? const LoaderWithDisable() : Container(),
            ],
          );
        },
      ),
    );
  }
}
