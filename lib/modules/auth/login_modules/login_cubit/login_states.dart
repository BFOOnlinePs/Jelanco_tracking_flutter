import 'package:jelanco_tracking_system/models/auth_models/user_login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final UserLoginModel userLoginModel;

  LoginSuccessState({required this.userLoginModel});
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState({required this.error});
}
