import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/add_role_model.dart';

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

class AddRoleLoadingState extends RolePermissionsManagementStates {}

class AddRoleSuccessState extends RolePermissionsManagementStates {
  final AddEditRoleModel? addRoleModel;

  AddRoleSuccessState(this.addRoleModel);
}

class AddRoleErrorState extends RolePermissionsManagementStates {}

class EditRoleLoadingState extends RolePermissionsManagementStates {}

class EditRoleSuccessState extends RolePermissionsManagementStates {
  final AddEditRoleModel? editRoleModel;

  EditRoleSuccessState(this.editRoleModel);
}

class EditRoleErrorState extends RolePermissionsManagementStates {}

class ChangeRoleNameState extends RolePermissionsManagementStates {}

// all permissions mixin
class GetAllPermissionsLoadingState extends RolePermissionsManagementStates {}

class GetAllPermissionsSuccessState extends RolePermissionsManagementStates {}

class GetAllPermissionsErrorState extends RolePermissionsManagementStates {}
