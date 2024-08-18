abstract class TaskSubmissionVersionsStates {}

class TaskSubmissionVersionsInitialState extends TaskSubmissionVersionsStates {}

class GetTaskSubmissionVersionsLoadingState
    extends TaskSubmissionVersionsStates {}

class GetTaskSubmissionVersionsSuccessState
    extends TaskSubmissionVersionsStates {}

class GetTaskSubmissionVersionsErrorState extends TaskSubmissionVersionsStates {
  final String error;

  GetTaskSubmissionVersionsErrorState({required this.error});
}
