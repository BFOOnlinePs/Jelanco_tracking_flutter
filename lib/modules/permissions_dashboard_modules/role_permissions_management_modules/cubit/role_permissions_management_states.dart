abstract class RolePermissionsManagementStates {}

class RolePermissionsManagementInitialState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsErrorState extends RolePermissionsManagementStates {}

class SetExpandedIndexState extends RolePermissionsManagementStates {}

class SetSelectedRolePermissionsIdsState extends RolePermissionsManagementStates {}

class AssignPermissionsToRoleLoadingState extends RolePermissionsManagementStates {}

class AssignPermissionsToRoleSuccessState extends RolePermissionsManagementStates {
  // todo add the model (status message)
}

class AssignPermissionsToRoleErrorState extends RolePermissionsManagementStates {}

// all permissions mixin
class GetAllPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllPermissionsErrorState extends RolePermissionsManagementStates {}
