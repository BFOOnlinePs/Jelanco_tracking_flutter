abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class GetUserSubmissionsLoadingState extends HomeStates {}

class GetUserSubmissionsSuccessState extends HomeStates {}

class GetUserSubmissionsErrorState extends HomeStates {
  final String error;

  GetUserSubmissionsErrorState(this.error);
}

class AfterEditSubmissionState extends HomeStates {}

// TasksToSubmitMixin
class GetTasksToSubmitLoadingState extends HomeStates {}

class GetTasksToSubmitSuccessState extends HomeStates {}

class GetTasksToSubmitErrorState extends HomeStates {
  final String error;

  GetTasksToSubmitErrorState(this.error);
}
