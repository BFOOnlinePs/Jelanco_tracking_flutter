abstract class UserPermissionsManagementStates {}

class UserPermissionsManagementInitialState extends UserPermissionsManagementStates {}

class GetAllUsersLoadingState extends UserPermissionsManagementStates {}

class GetAllUsersSuccessState extends UserPermissionsManagementStates {}

class GetAllUsersErrorState extends UserPermissionsManagementStates {}

// permissions mixin

class GetAllPermissionsLoadingState extends UserPermissionsManagementStates {}

class GetAllPermissionsSuccessState extends UserPermissionsManagementStates {}

class GetAllPermissionsErrorState extends UserPermissionsManagementStates {}

// roles mixin

class GetAllRolesLoadingState extends UserPermissionsManagementStates {}

class GetAllRolesSuccessState extends UserPermissionsManagementStates {}

class GetAllRolesErrorState extends UserPermissionsManagementStates {}
