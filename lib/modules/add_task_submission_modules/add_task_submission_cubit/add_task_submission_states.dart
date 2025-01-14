import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/add_task_submission_model.dart';

abstract class AddTaskSubmissionStates {}

class AddTaskSubmissionInitialState extends AddTaskSubmissionStates {}

class PickMultipleImagesState extends AddTaskSubmissionStates {}

class DeletePickedImageFromListState extends AddTaskSubmissionStates {}

class PickVideoState extends AddTaskSubmissionStates {}

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

class CheckBoxChangedState extends AddTaskSubmissionStates {}

class SetOldAttachmentsState extends AddTaskSubmissionStates {}

class ChangeContentMaxLinesState extends AddTaskSubmissionStates {}

class PickMediaFromCameraState extends AddTaskSubmissionStates {}

class PlannedTimePickedState extends AddTaskSubmissionStates {}

class GetOldSubmissionDataLoadingState extends AddTaskSubmissionStates {}

class GetOldSubmissionDataSuccessState extends AddTaskSubmissionStates {}

class GetOldSubmissionDataErrorState extends AddTaskSubmissionStates {
  final String error;
  GetOldSubmissionDataErrorState({required this.error});
}

// compress images mixin

class CompressAllImagesLoadingState extends AddTaskSubmissionStates {}

class CompressAllImagesSuccessState extends AddTaskSubmissionStates {}

// compress video mixin

class CompressVideoLoadingState extends AddTaskSubmissionStates {}

class CompressVideoSuccessState extends AddTaskSubmissionStates {}

class CompressVideoErrorState extends AddTaskSubmissionStates {
  final String error;

  CompressVideoErrorState({required this.error});
}

class CompressAllVideosSuccessState extends AddTaskSubmissionStates {}

// Categories Mixin

class CategoriesLoadingState extends AddTaskSubmissionStates {}

class CategoriesSuccessState extends AddTaskSubmissionStates {}

class CategoriesErrorState extends AddTaskSubmissionStates {
  final String error;

  CategoriesErrorState({required this.error});
}
