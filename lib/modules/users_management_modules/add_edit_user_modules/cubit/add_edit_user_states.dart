import 'package:jelanco_tracking_system/models/users_models/add_update_user_model.dart';

abstract class AddEditUserStates {}

class AddUserInitialState extends AddEditUserStates {}

class TogglePasswordVisibilityState extends AddEditUserStates {}

class AddUserLoadingState extends AddEditUserStates {}

class AddUserSuccessState extends AddEditUserStates {
  final AddUpdateUserModel addUserModel;

  AddUserSuccessState(this.addUserModel);
}

class AddUserErrorState extends AddEditUserStates {}

class UpdateUserLoadingState extends AddEditUserStates {}

class UpdateUserSuccessState extends AddEditUserStates {
  final AddUpdateUserModel addUserModel;

  UpdateUserSuccessState(this.addUserModel);
}

class UpdateUserErrorState extends AddEditUserStates {}

class InitializeDataDoneState extends AddEditUserStates {}

// departments mixins

class GetAllDepartmentsLoadingState extends AddEditUserStates {}

class GetAllDepartmentsSuccessState extends AddEditUserStates {}

class GetAllDepartmentsErrorState extends AddEditUserStates {}

// get user by id mixins

class GetUserByIdLoadingState extends AddEditUserStates {}

class GetUserByIdSuccessState extends AddEditUserStates {}

class GetUserByIdErrorState extends AddEditUserStates {}