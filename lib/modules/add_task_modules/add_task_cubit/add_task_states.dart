import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class PlannedTimePickedState extends AddTaskStates {}

class FilterUsersOnSearchState extends AddTaskStates {}

class CheckBoxChangedState extends AddTaskStates {}

class ChangeSelectedUsersState extends AddTaskStates {}

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

// Users Mixin

class GetAllUsersLoadingState extends AddTaskStates {}

class GetAllUsersSuccessState extends AddTaskStates {}

class GetAllUsersErrorState extends AddTaskStates {
  final String error;

  GetAllUsersErrorState({required this.error});
}

// Assigned To Mixin

