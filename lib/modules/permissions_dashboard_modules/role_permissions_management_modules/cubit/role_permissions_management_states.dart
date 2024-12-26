import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';

abstract class RolePermissionsManagementStates {}

class RolePermissionsManagementInitialState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllRolesWithPermissionsErrorState extends RolePermissionsManagementStates {}

class SetExpandedIndexState extends RolePermissionsManagementStates {}

class SetSelectedRolePermissionsIdsState extends RolePermissionsManagementStates {}

class AssignPermissionsToRoleLoadingState extends RolePermissionsManagementStates {}

class AssignPermissionsToRoleSuccessState extends RolePermissionsManagementStates {
  final StatusMessageModel? assignPermissionsToRoleStatusMessageModel;

  AssignPermissionsToRoleSuccessState(this.assignPermissionsToRoleStatusMessageModel);
}

class AssignPermissionsToRoleErrorState extends RolePermissionsManagementStates {}

// all permissions mixin
class GetAllPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllPermissionsErrorState extends RolePermissionsManagementStates {}
