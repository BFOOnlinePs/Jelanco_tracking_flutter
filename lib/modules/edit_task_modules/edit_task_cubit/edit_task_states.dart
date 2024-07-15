import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_cubit.dart';

abstract class EditTaskStates {}

class EditTaskInitialState extends EditTaskStates {}

class EditTaskLoadingState extends EditTaskStates {}

class EditTaskSuccessState extends EditTaskStates {
  final EditTaskModel editTaskModel;

  EditTaskSuccessState({required this.editTaskModel});
}

class EditTaskErrorState extends EditTaskStates {
  final String error;

  EditTaskErrorState({required this.error});
}
