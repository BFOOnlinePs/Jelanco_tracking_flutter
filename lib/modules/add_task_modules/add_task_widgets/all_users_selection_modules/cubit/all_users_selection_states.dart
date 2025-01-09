import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';

abstract class AllUsersSelectionStates {}

class AllUsersSelectionInitialState extends AllUsersSelectionStates {}

class ToggleSelectedUsersState extends AllUsersSelectionStates {}

class InitialValuesState extends AllUsersSelectionStates {}

// users mixin

class GetAllUsersLoadingState extends AllUsersSelectionStates {}

class GetAllUsersSuccessState extends AllUsersSelectionStates {}

class GetAllUsersErrorState extends AllUsersSelectionStates {}

// interested parties mixin

class GetInterestedPartiesLoadingState extends AllUsersSelectionStates {}

class GetInterestedPartiesSuccessState extends AllUsersSelectionStates {}

class GetInterestedPartiesErrorState extends AllUsersSelectionStates {}

// handle interested parties

class HandleInterestedPartiesLoadingState extends AllUsersSelectionStates {}

class HandleInterestedPartiesSuccessState extends AllUsersSelectionStates {
  final StatusMessageModel handleInterestedPartiesStatusMessageModel;

  HandleInterestedPartiesSuccessState(this.handleInterestedPartiesStatusMessageModel);
}

class HandleInterestedPartiesErrorState extends AllUsersSelectionStates {}
