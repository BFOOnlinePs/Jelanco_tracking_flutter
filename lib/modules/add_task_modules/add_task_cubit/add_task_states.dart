import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';

import '../../../core/utils/mixins/categories_mixin/categories_states.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class CategoriesMixinStates extends AddTaskStates {} // for the mixin

class UsersMixinStates extends AddTaskStates {} // for the mixin

class PlannedTimePickedState extends AddTaskStates {}

class FilterUsersOnSearchState extends AddTaskStates {}

class CheckBoxChangedState extends AddTaskStates {}

class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {
  final AddTaskModel addTaskModel;

  AddTaskSuccessState({required this.addTaskModel});
}

class AddTaskErrorState extends AddTaskStates {
  final String error;

  AddTaskErrorState({required this.error});
}
