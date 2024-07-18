abstract class TaskDetailsStates {}

class TaskDetailsInitialState extends TaskDetailsStates {}

class TaskDetailsLoadingState extends TaskDetailsStates {}

class TaskDetailsSuccessState extends TaskDetailsStates {}

class TaskDetailsErrorState extends TaskDetailsStates {
  final String error;
  TaskDetailsErrorState({required this.error});
}