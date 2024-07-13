// abstract class CategoriesMixinStates {}

import '../../../../modules/add_task_modules/add_task_cubit/add_task_states.dart';

class CategoriesLoadingState extends CategoriesMixinStates {}

class CategoriesSuccessState extends CategoriesMixinStates {}

class CategoriesErrorState extends CategoriesMixinStates {
  final String error;

  CategoriesErrorState({required this.error});
}
