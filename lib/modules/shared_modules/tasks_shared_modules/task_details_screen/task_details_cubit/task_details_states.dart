abstract class TaskDetailsStates {}

class TaskDetailsInitialState extends TaskDetailsStates {}

class TaskDetailsLoadingState extends TaskDetailsStates {}

class TaskDetailsSuccessState extends TaskDetailsStates {}

class TaskDetailsErrorState extends TaskDetailsStates {
  final String error;

  TaskDetailsErrorState({required this.error});
}

class InitializeVideoControllerState extends TaskDetailsStates {}

class ToggleVideoPlayPauseState extends TaskDetailsStates {}

class ListenToNewCommentsState extends TaskDetailsStates {}

class AfterEditTaskState extends TaskDetailsStates {}

class TasksUpdatedStateViaEventBus extends TaskDetailsStates {}
