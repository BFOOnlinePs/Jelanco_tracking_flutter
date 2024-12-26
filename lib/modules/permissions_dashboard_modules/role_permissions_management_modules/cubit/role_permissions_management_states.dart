abstract class RolePermissionsManagementStates {}

class RolePermissionsManagementInitialState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsErrorState extends RolePermissionsManagementStates {}

class SetExpandedIndexState extends RolePermissionsManagementStates {}