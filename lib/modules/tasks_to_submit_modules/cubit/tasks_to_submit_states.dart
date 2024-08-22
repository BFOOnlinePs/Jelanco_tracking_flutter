abstract class TasksToSubmitStates {}

class TasksToSubmitInitialState extends TasksToSubmitStates {}

// TasksToSubmitMixin
class GetTasksToSubmitLoadingState extends TasksToSubmitStates {}

class GetTasksToSubmitSuccessState extends TasksToSubmitStates {}

class GetTasksToSubmitErrorState extends TasksToSubmitStates {
  final String error;

  GetTasksToSubmitErrorState(this.error);
}
