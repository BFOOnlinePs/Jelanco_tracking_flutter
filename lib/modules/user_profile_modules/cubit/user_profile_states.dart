abstract class UserProfileStates {}

class UserProfileInitialState extends UserProfileStates {}

class GetUserProfileLoadingState extends UserProfileStates {}

class GetUserProfileSuccessState extends UserProfileStates {}

class GetUserProfileErrorState extends UserProfileStates {}

class GetCommentsCountLoadingState extends UserProfileStates {}

class GetCommentsCountSuccessState extends UserProfileStates {}

class GetCommentsCountErrorState extends UserProfileStates {}

class AfterEditSubmissionState extends UserProfileStates {}
