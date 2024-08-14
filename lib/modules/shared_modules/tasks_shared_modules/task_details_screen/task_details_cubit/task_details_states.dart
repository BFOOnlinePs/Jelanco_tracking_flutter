import 'package:jelanco_tracking_system/models/tasks_models/comments_models/add_task_submission_comment_model.dart';

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

class AddCommentLoadingState extends TaskDetailsStates {}

class AddCommentSuccessState extends TaskDetailsStates {
  final AddTaskSubmissionCommentModel addTaskSubmissionCommentModel;

  AddCommentSuccessState({required this.addTaskSubmissionCommentModel});
}

class AddCommentErrorState extends TaskDetailsStates {
  final String error;

  AddCommentErrorState({required this.error});
}

class ClearCommentControllerState extends TaskDetailsStates {}

class PickMultipleImagesState extends TaskDetailsStates {}

class DeletePickedImageFromListState extends TaskDetailsStates {}

class PickMultipleVideosState extends TaskDetailsStates {}

class DeletePickedVideoFromListState extends TaskDetailsStates {}

// compress images mixin

class CompressAllImagesLoadingState extends TaskDetailsStates {}

class CompressAllImagesSuccessState extends TaskDetailsStates {}

class AddTaskSubmissionFileSelectSuccessState extends TaskDetailsStates {}

class AddTaskSubmissionFileSelectErrorState extends TaskDetailsStates {
  final String error;

  AddTaskSubmissionFileSelectErrorState({required this.error});
}

class DeletePickedFilesFromListState extends TaskDetailsStates {}

// compress video mixin

class CompressAllVideosSuccessState extends TaskDetailsStates {}

class CompressVideoLoadingState extends TaskDetailsStates {}

class CompressVideoSuccessState extends TaskDetailsStates {}

class CompressVideoErrorState extends TaskDetailsStates {
  final String error;

  CompressVideoErrorState({required this.error});
}
