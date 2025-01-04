import 'package:jelanco_tracking_system/models/users_models/add_update_user_model.dart';

abstract class AddEditUserStates {}

class AddUserInitialState extends AddEditUserStates {}

class TogglePasswordVisibilityState extends AddEditUserStates {}

class AddUpdateUserLoadingState extends AddEditUserStates {}

class AddUpdateUserSuccessState extends AddEditUserStates {
  final AddUpdateUserModel addUserModel;

  AddUpdateUserSuccessState(this.addUserModel);
}

class AddUpdateUserErrorState extends AddEditUserStates {}

class InitializeDataDoneState extends AddEditUserStates {}

class UpdateUserStatusState extends AddEditUserStates {}

// departments mixins

class GetAllDepartmentsLoadingState extends AddEditUserStates {}

class GetAllDepartmentsSuccessState extends AddEditUserStates {}

class GetAllDepartmentsErrorState extends AddEditUserStates {}

// get user by id mixins

class GetUserByIdLoadingState extends AddEditUserStates {}

class GetUserByIdSuccessState extends AddEditUserStates {}

class GetUserByIdErrorState extends AddEditUserStates {}
