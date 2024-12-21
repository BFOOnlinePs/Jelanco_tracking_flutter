import 'package:jelanco_tracking_system/models/users_models/add_user_model.dart';

abstract class AddUserStates {}

class AddUserInitialState extends AddUserStates {}

class TogglePasswordVisibilityState extends AddUserStates {}

class AddUserLoadingState extends AddUserStates {}

class AddUserSuccessState extends AddUserStates {
  final AddUserModel addUserModel;

  AddUserSuccessState(this.addUserModel);
}

class AddUserErrorState extends AddUserStates {}

// departments mixins

class GetAllDepartmentsLoadingState extends AddUserStates {}

class GetAllDepartmentsSuccessState extends AddUserStates {}

class GetAllDepartmentsErrorState extends AddUserStates {}
