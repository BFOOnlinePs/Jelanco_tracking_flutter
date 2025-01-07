import 'package:jelanco_tracking_system/models/permissions_management_models/add_update_permission_model.dart';

abstract class PermissionsManagementStates {}

class PermissionsManagementInitialState extends PermissionsManagementStates {}

class GetAllPermissionsLoadingState extends PermissionsManagementStates {}

class GetAllPermissionsSuccessState extends PermissionsManagementStates {}

class GetAllPermissionsErrorState extends PermissionsManagementStates {}

class AddPermissionLoadingState extends PermissionsManagementStates {}

class AddPermissionSuccessState extends PermissionsManagementStates {
  final AddUpdatePermissionModel addPermissionModel;

  AddPermissionSuccessState(this.addPermissionModel);
}

class AddPermissionErrorState extends PermissionsManagementStates {}

class ChangePermissionNameState extends PermissionsManagementStates {}

class UpdatePermissionLoadingState extends PermissionsManagementStates {}

class UpdatePermissionSuccessState extends PermissionsManagementStates {
  final AddUpdatePermissionModel updatePermissionModel;

  UpdatePermissionSuccessState(this.updatePermissionModel);
}

class UpdatePermissionErrorState extends PermissionsManagementStates {}
