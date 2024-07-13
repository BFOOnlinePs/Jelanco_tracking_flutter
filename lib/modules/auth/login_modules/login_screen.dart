import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/core/utils/validation_utils.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_cubit/login_cubit.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_cubit/login_states.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_auth_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../../core/constants/user_data.dart';
import '../../../network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       ColorsConstants.primaryColor,
          //       ColorsConstants.primaryColor
          //     ],
          //   ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Image.asset(
                'assets/images/jelanco_logo.png',
                height: SharedSize.logoImageHeight,
              ),
              Spacer(),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstants.primaryColor,
                ),
              ),
              Text(
                'Login to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorsConstants.primaryColor,
                ),
              ),
              // Spacer(),
              MyVerticalSpacer(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: BlocProvider(
                  create: (context) => LoginCubit(),
                  child: BlocConsumer<LoginCubit, LoginStates>(
                    listener: (context, state) async {
                      if (state is LoginSuccessState) {
                        if (state.userLoginModel.status == true) {
                          print(state.userLoginModel.message);
                          await CacheHelper.saveData(
                            key: MyCacheKeys.token,
                            value: state.userLoginModel.token,
                          ).then((value) async {
                            await CacheHelper.saveData(
                              key: MyCacheKeys.userId,
                              value: state.userLoginModel.user!.id,
                            );
                            UserDataConstants.token =
                                state.userLoginModel.token;
                            UserDataConstants.userId =
                                state.userLoginModel.user!.id;

                            // to give it an FCM token and save it in the database
                            // await FirebaseApi().initNotification();
                            // firebaseTokenVar = CacheHelper.getData(key: 'firebaseToken');

                            // navigateAndFinishScreens(
                            //   context,
                            //   HomeScreen(),
                            // );
                          });
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
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.person),
                              controller: loginCubit.emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!ValidationUtils.isEmailValid(value)) {
                                  return "Email format is not valid";
                                }
                                return null;
                              },
                            ),
                            const MyVerticalSpacer(),
                            MyTextFormField(
                              labelText: 'Password',
                              controller: loginCubit.passwordController,
                              prefixIcon: Icon(Icons.lock),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Forgot Password?',
                                    style: TextStyle(
                                        color: ColorsConstants.primaryColor)),
                              ),
                            ),
                            const MyVerticalSpacer(),
                            MyAuthElevatedButton(
                              onPressed: state is LoginLoadingState
                                  ? null
                                  : () {
                                      if (loginCubit.loginFormKey.currentState!
                                          .validate()) {
                                        loginCubit.userLogin();
                                        print('go to home');
                                      }
                                    },
                              child: state is LoginLoadingState
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
