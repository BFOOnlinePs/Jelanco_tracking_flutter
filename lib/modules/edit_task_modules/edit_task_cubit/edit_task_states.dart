import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_cubit.dart';

abstract class EditTaskStates {}

class EditTaskInitialState extends EditTaskStates {}

class CategoriesMixinStates extends EditTaskStates {} // for the mixin

class UsersMixinStates extends EditTaskStates {} // for the mixin

class InitialValuesState extends EditTaskStates {}

class FilterUsersOnSearchState extends EditTaskStates {}

class CheckBoxChangedState extends EditTaskStates {}

class PlannedTimePickedState extends EditTaskStates {}

class ChangeSelectedUsersState extends EditTaskStates {}

class ChangeSelectedCategoryState extends EditTaskStates {}

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

// Users Mixin

class GetAllUsersLoadingState extends EditTaskStates {}

class GetAllUsersSuccessState extends EditTaskStates {}

class GetAllUsersErrorState extends EditTaskStates {
  final String error;

  GetAllUsersErrorState({required this.error});
}
