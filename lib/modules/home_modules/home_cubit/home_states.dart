abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class GetUserSubmissionsLoadingState extends HomeStates {}

class GetUserSubmissionsSuccessState extends HomeStates {}

class GetUserSubmissionsErrorState extends HomeStates {
  final String error;

  GetUserSubmissionsErrorState(this.error);
}

class AfterEditSubmissionState extends HomeStates {}

class GetCommentsCountLoadingState extends HomeStates {}

class GetCommentsCountSuccessState extends HomeStates {}

class GetCommentsCountErrorState extends HomeStates {}

class GetUserByIdLoadingState extends HomeStates {}

class GetUserByIdSuccessState extends HomeStates {}

class GetUserByIdErrorState extends HomeStates {}

// TasksToSubmitMixin
class GetTasksToSubmitLoadingState extends HomeStates {}

class GetTasksToSubmitSuccessState extends HomeStates {}

class GetTasksToSubmitErrorState extends HomeStates {
  final String error;

  GetTasksToSubmitErrorState(this.error);
}

class ListenToNewNotificationsState extends HomeStates {}

// Notifications badge Mixin
class GetUnreadNotificationsCountSuccessState extends HomeStates {}

// class NotificationsBadgeChangedState extends HomeStates {}
