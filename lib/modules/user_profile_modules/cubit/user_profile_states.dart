import 'package:jelanco_tracking_system/models/users_models/update_profile_image_model.dart';

abstract class UserProfileStates {}

class UserProfileInitialState extends UserProfileStates {}

class GetUserProfileLoadingState extends UserProfileStates {}

class GetUserProfileSuccessState extends UserProfileStates {}

class GetUserProfileErrorState extends UserProfileStates {}

class GetCommentsCountLoadingState extends UserProfileStates {}

class GetCommentsCountSuccessState extends UserProfileStates {}

class GetCommentsCountErrorState extends UserProfileStates {}

// class AfterEditSubmissionState extends UserProfileStates {}

class TasksUpdatedStateViaEventBus extends UserProfileStates {}

class UpdateProfileImageLoadingState extends UserProfileStates {}

class UpdateProfileImageSuccessState extends UserProfileStates {
  final UpdateProfileImageModel updateProfileImageModel;

  UpdateProfileImageSuccessState({required this.updateProfileImageModel});
}

class UpdateProfileImageErrorState extends UserProfileStates {}

class PickImageFromGalleryState extends UserProfileStates {}
