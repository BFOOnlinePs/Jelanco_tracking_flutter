import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/add_task_submission_model.dart';

abstract class AddTaskSubmissionStates {}

class AddTaskSubmissionInitialState extends AddTaskSubmissionStates {}

class PickMultipleImagesState extends AddTaskSubmissionStates {}

class DeletePickedImageFromListState extends AddTaskSubmissionStates {}

class PickMultipleVideosState extends AddTaskSubmissionStates {}

class DeletePickedVideoFromListState extends AddTaskSubmissionStates {}

class RequestLocationPermissionGetDeniedState extends AddTaskSubmissionStates {}

class AddTaskSubmissionFileSelectSuccessState extends AddTaskSubmissionStates {}

class AddTaskSubmissionFileSelectErrorState extends AddTaskSubmissionStates {
  final String error;

  AddTaskSubmissionFileSelectErrorState({required this.error});
}

class DeletePickedFilesFromListState extends AddTaskSubmissionStates {}

class InitializeVideoControllerState extends AddTaskSubmissionStates {}

class ToggleVideoPlayPauseState extends AddTaskSubmissionStates {}

class AddTaskSubmissionLoadingState extends AddTaskSubmissionStates {}

class EmitLoadingState extends AddTaskSubmissionStates {}

class AddTaskSubmissionSuccessState extends AddTaskSubmissionStates {
  final AddTaskSubmissionModel addTaskSubmissionModel;

  AddTaskSubmissionSuccessState({required this.addTaskSubmissionModel});
}

class AddTaskSubmissionErrorState extends AddTaskSubmissionStates {
  final String error;

  AddTaskSubmissionErrorState({required this.error});
}

class CompressAllVideosSuccessState extends AddTaskSubmissionStates {}

class CompressAllImagesLoadingState extends AddTaskSubmissionStates {}

class CompressAllImagesSuccessState extends AddTaskSubmissionStates {}

// compress video mixin

class CompressVideoLoadingState extends AddTaskSubmissionStates {}

class CompressVideoSuccessState extends AddTaskSubmissionStates {}

class CompressVideoErrorState extends AddTaskSubmissionStates {
  final String error;

  CompressVideoErrorState({required this.error});
}

// compress image mixin

// class CompressImages
