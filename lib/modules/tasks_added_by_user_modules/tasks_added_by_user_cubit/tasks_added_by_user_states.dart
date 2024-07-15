abstract class TasksAddedByUserStates {}

class TasksAddedByUserInitialState extends TasksAddedByUserStates {}

class GetTasksAddedByUserLoadingState extends TasksAddedByUserStates {}

class GetTasksAddedByUserSuccessState extends TasksAddedByUserStates {}

class GetTasksAddedByUserErrorState extends TasksAddedByUserStates {
  final String error;

  GetTasksAddedByUserErrorState({required this.error});
}
