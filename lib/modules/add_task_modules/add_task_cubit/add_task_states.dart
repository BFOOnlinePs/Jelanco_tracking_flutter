import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_states.dart';
import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';

import '../../../core/utils/mixins/users_mixin/users_states.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class PlannedTimePickedState extends AddTaskStates {}

class FilterUsersOnSearchState extends AddTaskStates {}

class CheckBoxChangedState extends AddTaskStates {}

class ChangeSelectedUsersState extends AddTaskStates {}

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

