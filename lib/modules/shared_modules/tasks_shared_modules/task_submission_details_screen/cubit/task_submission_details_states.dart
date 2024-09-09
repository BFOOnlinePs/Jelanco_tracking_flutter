abstract class TaskSubmissionDetailsStates {}

class TaskSubmissionDetailsInitialState extends TaskSubmissionDetailsStates {}

class GetTaskSubmissionWithTaskAndCommentsLoadingState
    extends TaskSubmissionDetailsStates {}

class GetTaskSubmissionWithTaskAndCommentsSuccessState
    extends TaskSubmissionDetailsStates {}

class GetTaskSubmissionWithTaskAndCommentsErrorState
    extends TaskSubmissionDetailsStates {}

class ListenToNewCommentsState extends TaskSubmissionDetailsStates {}

class AfterEditSubmissionState extends TaskSubmissionDetailsStates {}
