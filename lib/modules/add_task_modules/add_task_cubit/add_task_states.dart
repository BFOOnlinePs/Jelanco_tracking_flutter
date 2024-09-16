import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class PlannedTimePickedState extends AddTaskStates {}

class FilterUsersOnSearchState extends AddTaskStates {}

class CheckBoxChangedState extends AddTaskStates {}

class EmitAfterReturnState extends AddTaskStates {}

class ChangeSelectedCategoryState extends AddTaskStates {}

class ChangeIsAddClickedState extends AddTaskStates {}

class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {
  final AddTaskModel addTaskModel;

  AddTaskSuccessState({required this.addTaskModel});
}

class AddTaskErrorState extends AddTaskStates {
  final String error;

  AddTaskErrorState({required this.error});
}

// Categories Mixin

class CategoriesLoadingState extends AddTaskStates {}

class CategoriesSuccessState extends AddTaskStates {}

class CategoriesErrorState extends AddTaskStates {
  final String error;

  CategoriesErrorState({required this.error});
}

// Manager Employees Mixin

class GetManagerEmployeesLoadingState extends AddTaskStates {}

class GetManagerEmployeesSuccessState extends AddTaskStates {}

class GetManagerEmployeesErrorState extends AddTaskStates {}

