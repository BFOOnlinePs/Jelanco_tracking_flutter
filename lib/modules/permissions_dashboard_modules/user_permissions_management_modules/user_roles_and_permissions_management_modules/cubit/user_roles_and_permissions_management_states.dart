import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';

abstract class UserRolesAndPermissionsManagementStates {}

class UserRolesAndPermissionsManagementInitialState extends UserRolesAndPermissionsManagementStates {}

class UserRolesAndPermissionsManagementLoadingState extends UserRolesAndPermissionsManagementStates {}

class UserRolesAndPermissionsManagementSuccessState extends UserRolesAndPermissionsManagementStates {}

class UserRolesAndPermissionsManagementErrorState extends UserRolesAndPermissionsManagementStates {}

class ToggleRoleSelectionState extends UserRolesAndPermissionsManagementStates {}

class TogglePermissionSelectionState extends UserRolesAndPermissionsManagementStates {}

class AssignRolesToUserLoadingState extends UserRolesAndPermissionsManagementStates {}

class AssignRolesToUserSuccessState extends UserRolesAndPermissionsManagementStates {
  final StatusMessageModel assignRolesToUserModel;

  AssignRolesToUserSuccessState(this.assignRolesToUserModel);
}

class AssignRolesToUserErrorState extends UserRolesAndPermissionsManagementStates {}

class AssignPermissionsToUserLoadingState extends UserRolesAndPermissionsManagementStates {}

class AssignPermissionsToUserSuccessState extends UserRolesAndPermissionsManagementStates {
  final StatusMessageModel assignPermissionsToUserModel;

  AssignPermissionsToUserSuccessState(this.assignPermissionsToUserModel);
}

class AssignPermissionsToUserErrorState extends UserRolesAndPermissionsManagementStates {}

class ExcludePermissionsOfSelectedRolesState extends UserRolesAndPermissionsManagementStates {}