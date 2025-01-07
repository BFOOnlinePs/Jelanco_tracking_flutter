import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/validation_utils.dart';
import 'package:jelanco_tracking_system/modules/change_password_module/cubit/change_password_cubit.dart';
import 'package:jelanco_tracking_system/modules/change_password_module/cubit/change_password_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'تغيير كلمة المرور'),
      body: BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessState) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: state.statusMessageModel.status == true ? SnackBarStates.success : SnackBarStates.error,
                message: state.statusMessageModel.message ?? '',
              );
              // if (state.statusMessageModel.status == true) {
              //   NavigationServices.back(context);
              // }
            }
          },
          builder: (context, state) {
            ChangePasswordCubit changePasswordCubit = ChangePasswordCubit.get(context);
            return Stack(
              children: [
                MyScreen(
                  child: SingleChildScrollView(
                    child: Form(
                      key: changePasswordCubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MyScreenTitleWidget(title: 'قم بتغيير كلمة المرور الخاصة بك'),
                          const MyVerticalSpacer(),
                          MyTextFormField(
                            titleText: 'كلمة المرور الجديدة',
                            labelText: 'كلمة المرور الجديدة',
                            obscureText: changePasswordCubit.isVisibleFor('newPassword'),
                            controller: changePasswordCubit.passwordController,
                            textInputAction: TextInputAction.next,
                            isFieldRequired: true,
                            suffixIcon: InkWell(
                              onTap: () {
                                changePasswordCubit.togglePasswordVisibilityFor(
                                    key: 'newPassword', passwordVisibilityState: TogglePasswordVisibilityState());
                              },
                              child: Icon(
                                changePasswordCubit.isVisibleFor('newPassword') ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              if (!ValidationUtils.isPasswordValid(value)) {
                                return 'كلمة المرور يجب ان تكون على الاقل 8 حروف';
                              }
                              return null;
                            },
                          ),
                          MyTextFormField(
                            controller: changePasswordCubit.confirmPasswordController,
                            titleText: 'تاكيد كلمة المرور الجديدة',
                            labelText: 'تاكيد كلمة المرور الجديدة',
                            obscureText: changePasswordCubit.isVisibleFor('confirmPassword'),
                            suffixIcon: InkWell(
                              onTap: () {
                                changePasswordCubit.togglePasswordVisibilityFor(
                                    key: 'confirmPassword', passwordVisibilityState: TogglePasswordVisibilityState());
                              },
                              child: Icon(
                                changePasswordCubit.isVisibleFor('confirmPassword') ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            isFieldRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء تأكيد كلمة المرور';
                              }
                              if (value != changePasswordCubit.passwordController.text) {
                                return 'كلمة المرور غير متطابقة';
                              }
                              return null;
                            },
                          ),
                          const MyVerticalSpacer(),
                          MyElevatedButton(
                            onPressed: changePasswordCubit.changePassword,
                            buttonText: 'تغيير كلمة المرور',
                            isWidthFull: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is ChangePasswordLoadingState) const LoaderWithDisable()
              ],
            );
          },
        ),
      ),
    );
  }
}
