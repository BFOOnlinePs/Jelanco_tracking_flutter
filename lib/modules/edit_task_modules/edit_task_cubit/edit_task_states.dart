import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';

abstract class EditTaskStates {}

class EditTaskInitialState extends EditTaskStates {}

class CategoriesMixinStates extends EditTaskStates {} // for the mixin

class UsersMixinStates extends EditTaskStates {} // for the mixin

class InitialValuesState extends EditTaskStates {}

class FilterUsersOnSearchState extends EditTaskStates {}

class CheckBoxChangedState extends EditTaskStates {}

class PlannedTimePickedState extends EditTaskStates {}

class EmitAfterReturnState extends EditTaskStates {}

class ChangeSelectedCategoryState extends EditTaskStates {}

class ChangeSelectedTaskStatusState extends EditTaskStates {}

class EditTaskLoadingState extends EditTaskStates {}

class EditTaskSuccessState extends EditTaskStates {
  final EditTaskModel editTaskModel;

  EditTaskSuccessState({required this.editTaskModel});
}

class EditTaskErrorState extends EditTaskStates {
  final String error;

  EditTaskErrorState({required this.error});
}

// Categories Mixin

class CategoriesLoadingState extends EditTaskStates {}

class CategoriesSuccessState extends EditTaskStates {}

class CategoriesErrorState extends EditTaskStates {
  final String error;

  CategoriesErrorState({required this.error});
}

// Manager Employees Mixin

class GetManagerEmployeesLoadingState extends EditTaskStates {}

class GetManagerEmployeesSuccessState extends EditTaskStates {}

class GetManagerEmployeesErrorState extends EditTaskStates {}
