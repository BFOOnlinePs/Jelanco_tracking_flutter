import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/utils/user_data_utils.dart';
import 'package:jelanco_tracking_system/core/utils/validation_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_cubit/login_cubit.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_cubit/login_states.dart';
import 'package:jelanco_tracking_system/network/remote/firebase_api.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_auth_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../home_modules/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(flex: 2),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.12), // Instead of Spacer
            Image.asset(
              AssetsKeys.appLogo,
              height: SharedSize.logoImageHeight,
            ),
            // const Spacer(),
            SizedBox(height: 20.sp), // Instead of Spacer

            Text(
              'login_title'.tr(),
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.primaryColor,
              ),
            ),
            Text(
              'login_subtitle'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorsConstants.primaryColor,
              ),
            ),
            MyVerticalSpacer(
              height: 24.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: BlocProvider(
                create: (context) => LoginCubit(),
                child: BlocConsumer<LoginCubit, LoginStates>(
                  listener: (context, state) async {
                    if (state is LoginSuccessState) {
                      if (state.userLoginModel.status == true) {
                        print(state.userLoginModel.message);
                        await UserDataUtils.saveUserDataToLocalStorage(
                            userLoginModel: state.userLoginModel);

                        // for firebase token
                        await FirebaseApi().initNotification();

                        NavigationServices.navigateTo(
                          context,
                          HomeScreen(),
                          // BottomNavBarScreens(),
                          removeAll: true,
                        );
                      } else {
                        print(state.userLoginModel.message);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.userLoginModel.message ?? "Error !!",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else if (state is LoginErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.error,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    LoginCubit loginCubit = LoginCubit.get(context);
                    return Form(
                      key: loginCubit.loginFormKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            labelText: 'login_email_field'.tr(),
                            prefixIcon: const Icon(Icons.person),
                            controller: loginCubit.emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "login_email_field_required_validation"
                                    .tr();
                              }
                              if (!ValidationUtils.isEmailValid(value)) {
                                return "login_email_field_format_validation"
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          MyVerticalSpacer(
                            height: 8.h,
                          ),
                          MyTextFormField(
                            labelText: 'login_password_field'.tr(),
                            controller: loginCubit.passwordController,
                            prefixIcon: const Icon(Icons.lock),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "login_password_field_required_validation"
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: () {},
                              child: Text('login_forgot_password'.tr(),
                                  style: TextStyle(
                                      color: ColorsConstants.primaryColor,
                                      fontSize: 14.sp)),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                loginCubit.selectActor(newId: 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black26,
                              ),
                              child: Text(
                                'مستخدم',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              ),
                            ),
                          ),
                          const MyVerticalSpacer(),
                          MyAuthElevatedButton(
                            onPressed: state is LoginLoadingState
                                ? null
                                : () {
                                    if (loginCubit.loginFormKey.currentState!
                                        .validate()) {
                                      loginCubit.userLogin(context);
                                    }
                                  },
                            child: state is LoginLoadingState
                                ? const MyLoader(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'login_login_button'.tr(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.sp),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // const Spacer(flex: 2),
            // SizedBox(height: 80.sp), // Instead of Spacer
          ],
        ),
      ),
    );
  }
}
