abstract class UsersManagementStates {}

class UsersManagementInitialState extends UsersManagementStates {}

// users mixin

class GetAllUsersLoadingState extends UsersManagementStates {}

class GetAllUsersSuccessState extends UsersManagementStates {}

class GetAllUsersErrorState extends UsersManagementStates {}
