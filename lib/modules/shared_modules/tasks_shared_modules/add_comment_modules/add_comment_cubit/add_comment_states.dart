import 'package:jelanco_tracking_system/models/tasks_models/comments_models/add_task_submission_comment_model.dart';

abstract class AddCommentStates {}

class AddCommentInitialState extends AddCommentStates {}

class AddCommentLoadingState extends AddCommentStates {}

class AddCommentSuccessState extends AddCommentStates {
  final AddTaskSubmissionCommentModel addTaskSubmissionCommentModel;

  AddCommentSuccessState({required this.addTaskSubmissionCommentModel});
}

class AddCommentErrorState extends AddCommentStates {
  final String error;

  AddCommentErrorState({required this.error});
}

class ClearCommentControllerState extends AddCommentStates {}

class ChangeCommentTextState extends AddCommentStates {}


class PickMediaFromCameraState extends AddCommentStates {}

class PickMultipleImagesState extends AddCommentStates {}

class DeletePickedImageFromListState extends AddCommentStates {}

class PickVideosState extends AddCommentStates {}

class DeletePickedVideoFromListState extends AddCommentStates {}

// compress images mixin

class CompressAllImagesLoadingState extends AddCommentStates {}

class CompressAllImagesSuccessState extends AddCommentStates {}

class AddTaskSubmissionFileSelectSuccessState extends AddCommentStates {}

class AddTaskSubmissionFileSelectErrorState extends AddCommentStates {
  final String error;

  AddTaskSubmissionFileSelectErrorState({required this.error});
}

class DeletePickedFilesFromListState extends AddCommentStates {}

// compress video mixin

class CompressAllVideosSuccessState extends AddCommentStates {}

class CompressVideoLoadingState extends AddCommentStates {}

class CompressVideoSuccessState extends AddCommentStates {}

class CompressVideoErrorState extends AddCommentStates {
  final String error;

  CompressVideoErrorState({required this.error});
}
