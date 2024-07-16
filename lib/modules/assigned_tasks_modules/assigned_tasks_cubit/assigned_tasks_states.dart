abstract class AssignedTasksStates {}

class AssignedTasksInitialState extends AssignedTasksStates {}

class GetAssignedTasksLoadingState extends AssignedTasksStates {}

class GetAssignedTasksSuccessState extends AssignedTasksStates {}

class GetAssignedTasksErrorState extends AssignedTasksStates {
  final String error;

  GetAssignedTasksErrorState({required this.error});
}
