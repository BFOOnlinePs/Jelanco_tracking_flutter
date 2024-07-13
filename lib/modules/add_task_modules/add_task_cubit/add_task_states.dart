import '../../../core/utils/mixins/categories_mixin/categories_states.dart';

abstract class AddTaskStates {}

class CategoriesMixinStates extends AddTaskStates {} // for the mixin

class AddTaskInitialState extends AddTaskStates {}


class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {
  //
}

class AddTaskErrorState extends AddTaskStates {
  final String error;

  AddTaskErrorState({required this.error});
}
