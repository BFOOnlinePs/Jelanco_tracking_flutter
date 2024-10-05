import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';

abstract class AddEditUsersStates {}

class AddEditUsersInitialState extends AddEditUsersStates {}

class UsersSearchState extends AddEditUsersStates {}

class ToggleUsersSelectionState extends AddEditUsersStates {}

class AddEditManagerEmployeesLoadingState extends AddEditUsersStates {}

class AddEditManagerEmployeesSuccessState extends AddEditUsersStates {
  final AddEditManagerEmployeesModel addEditManagerEmployeesModel;

  AddEditManagerEmployeesSuccessState(this.addEditManagerEmployeesModel);
}

class AddEditManagerEmployeesErrorState extends AddEditUsersStates {}

class GetManagerEmployeesByIdLoadingState extends AddEditUsersStates {}

class GetManagerEmployeesByIdSuccessState extends AddEditUsersStates {}

class GetManagerEmployeesByIdErrorState extends AddEditUsersStates {}

// users mixin

class GetAllUsersLoadingState extends AddEditUsersStates {}

class GetAllUsersSuccessState extends AddEditUsersStates {}

class GetAllUsersErrorState extends AddEditUsersStates {}
