abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class GetUserSubmissionsLoadingState extends HomeStates {}

class GetUserSubmissionsSuccessState extends HomeStates {}

class GetUserSubmissionsErrorState extends HomeStates {
  final String error;

  GetUserSubmissionsErrorState(this.error);
}
