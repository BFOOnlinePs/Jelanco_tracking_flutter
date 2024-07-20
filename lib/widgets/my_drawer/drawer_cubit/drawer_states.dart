import 'package:jelanco_tracking_system/models/auth_models/user_logout_model.dart';

abstract class DrawerStates {}

class DrawerInitialState extends DrawerStates {}

class LogoutLoadingState extends DrawerStates {}

class LogoutSuccessState extends DrawerStates {
  UserLogoutModel userLogoutModel;

  LogoutSuccessState({required this.userLogoutModel});
}

class LogoutErrorState extends DrawerStates {
  final String error;

  LogoutErrorState({required this.error});
}
