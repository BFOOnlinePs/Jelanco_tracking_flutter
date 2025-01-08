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
