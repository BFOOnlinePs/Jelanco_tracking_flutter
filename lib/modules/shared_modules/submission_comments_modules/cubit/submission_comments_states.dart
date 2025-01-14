abstract class SubmissionCommentsStates {}

class SubmissionCommentsInitialState extends SubmissionCommentsStates {}

class GetSubmissionCommentsLoadingState extends SubmissionCommentsStates {}

class GetSubmissionCommentsSuccessState extends SubmissionCommentsStates {}

class GetSubmissionCommentsErrorState extends SubmissionCommentsStates {
  final String error;

  GetSubmissionCommentsErrorState(this.error);
}

class OpenSheetState extends SubmissionCommentsStates {}

class ListenToNewCommentsState extends SubmissionCommentsStates {}
