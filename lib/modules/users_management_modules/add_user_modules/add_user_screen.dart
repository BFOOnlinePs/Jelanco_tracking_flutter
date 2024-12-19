import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/validation_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_search.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_multi_selection_drop_down.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserCubit()..getAllDepartments(),
      child: BlocConsumer<AddUserCubit, AddUserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AddUserCubit addUserCubit = AddUserCubit.get(context);
          return Scaffold(
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

                    /// departments multi select drop down
                    addUserCubit.getDepartmentsModel == null
                        ? const Center(child: CircularProgressIndicator())
                        : MyMultiSelectDropDown<DepartmentModel>(
                            items: addUserCubit.getDepartmentsModel!.departments!
                                .map((e) => DropdownItem(label: e.dName ?? 'no dep name', value: e))
                                .toList(),
                          ),
                    // DropDown

                    MyElevatedButton(
                        onPressed: () {
                          if (addUserCubit.formKey.currentState!.validate()) {
                            /// if phone and email empty, show message that one of then is required
                            // add
                          }
                        },
                        buttonText: 'إضافة الموظف')
                  ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
