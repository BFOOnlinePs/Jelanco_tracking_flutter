abstract class AddTaskSubmissionStates {}

class AddTaskSubmissionInitialState extends AddTaskSubmissionStates {}

class PickMultipleImagesState extends AddTaskSubmissionStates {}

class DeletePickedImageFromListState extends AddTaskSubmissionStates {}

class PickMultipleVideosState extends AddTaskSubmissionStates {}

class DeletePickedVideoFromListState extends AddTaskSubmissionStates {}

class RequestLocationPermissionGetDeniedState extends AddTaskSubmissionStates {}

class AddTaskSubmissionFileSelectSuccessState extends AddTaskSubmissionStates {}

class AddTaskSubmissionFileSelectErrorState extends AddTaskSubmissionStates {}

class DeletePickedFilesFromListState extends AddTaskSubmissionStates {}

class InitializeVideoControllerState extends AddTaskSubmissionStates {}

class ToggleVideoPlayPauseState extends AddTaskSubmissionStates {}

class AddTaskSubmissionLoadingState extends AddTaskSubmissionStates {}

class AddTaskSubmissionSuccessState extends AddTaskSubmissionStates {}

class AddTaskSubmissionErrorState extends AddTaskSubmissionStates {
  final String error;

  AddTaskSubmissionErrorState({required this.error});
}
