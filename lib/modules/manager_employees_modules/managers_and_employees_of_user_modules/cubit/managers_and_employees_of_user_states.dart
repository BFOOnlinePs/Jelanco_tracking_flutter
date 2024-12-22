import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';

abstract class ManagersAndEmployeesOfUserStates {}

class ManagersAndEmployeesOfUserInitialState extends ManagersAndEmployeesOfUserStates {}

class GetManagersAndEmployeesOfUserLoadingState extends ManagersAndEmployeesOfUserStates {}

class GetManagersAndEmployeesOfUserSuccessState extends ManagersAndEmployeesOfUserStates {}

class GetManagersAndEmployeesOfUserErrorState extends ManagersAndEmployeesOfUserStates {}

class ToggleUsersSelectionState extends ManagersAndEmployeesOfUserStates {}

class EnterScreenActionsState extends ManagersAndEmployeesOfUserStates {}

class UsersSearchState extends ManagersAndEmployeesOfUserStates {}

class AddEditManagerEmployeesLoadingState extends ManagersAndEmployeesOfUserStates {}

class AddEditManagerEmployeesSuccessState extends ManagersAndEmployeesOfUserStates {
  final AddEditManagerEmployeesModel addEditManagerEmployeesModel;

  AddEditManagerEmployeesSuccessState(this.addEditManagerEmployeesModel);
}

class AddEditManagerEmployeesErrorState extends ManagersAndEmployeesOfUserStates {}

class AssignEmployeeForManagersLoadingState extends ManagersAndEmployeesOfUserStates {}

class AssignEmployeeForManagersSuccessState extends ManagersAndEmployeesOfUserStates {
  // todo add model
}

class AssignEmployeeForManagersErrorState extends ManagersAndEmployeesOfUserStates {}
// all users mixin

class GetAllUsersLoadingState extends ManagersAndEmployeesOfUserStates {}

class GetAllUsersSuccessState extends ManagersAndEmployeesOfUserStates {}

class GetAllUsersErrorState extends ManagersAndEmployeesOfUserStates {}
