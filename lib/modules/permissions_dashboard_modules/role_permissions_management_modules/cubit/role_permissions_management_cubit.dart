import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/system_permissions_mixin/system_permissions_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/system_roles_mixin/system_roles_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/add_role_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_all_roles_with_permissions_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class RolePermissionsManagementCubit extends Cubit<RolePermissionsManagementStates>
    with SystemPermissionsMixin<RolePermissionsManagementStates>, SystemRolesMixin<RolePermissionsManagementStates> {
  RolePermissionsManagementCubit() : super(RolePermissionsManagementInitialState());

  static RolePermissionsManagementCubit get(context) => BlocProvider.of(context);

  int expandedIndex = -1;

  void setExpandedIndex(int index) {
    selectedRolePermissionsIds.clear();
    print('expandedIndex: $expandedIndex');
    print('index: $index');
    if (index == expandedIndex) {
      expandedIndex = -1;
    } else {
      expandedIndex = index;
      // after 1 second, set the selected role permissions ids
      Future.delayed(const Duration(milliseconds: 500),
          () => setSelectedRolePermissionsIds(roleId: getAllRolesWithPermissionsModel!.roles![index].id!));
    }
    emit(SetExpandedIndexState());
  }

  List<int> selectedRolePermissionsIds = [];

  // set the selected role permissions ids when expand the role (depends on the role id)
  void setSelectedRolePermissionsIds({required int roleId}) {
    selectedRolePermissionsIds = getAllRolesWithPermissionsModel!.roles!
        .firstWhere((role) => role.id == roleId)
        .permissions!
        .map((permission) => permission.id!)
        .toList();
    emit(SetSelectedRolePermissionsIdsState());
  }

  void addRemoveSelectedRolePermissionsIds({required int permissionId}) {
    if (selectedRolePermissionsIds.contains(permissionId)) {
      selectedRolePermissionsIds.remove(permissionId);
    } else {
      selectedRolePermissionsIds.add(permissionId);
    }
    emit(SetSelectedRolePermissionsIdsState());
  }

  StatusMessageModel? assignPermissionsToRoleModel;

  void assignPermissionsToRole({required int roleId, required List<int> selectedRolePermissionsIds}) {
    emit(AssignPermissionsToRoleLoadingState());
    DioHelper.postData(
        url: '${EndPointsConstants.roles}/$roleId/${EndPointsConstants.permissions}',
        data: {"permissionIds": selectedRolePermissionsIds}).then((value) {
      print(value?.data);
      assignPermissionsToRoleModel = StatusMessageModel.fromMap(value?.data);
      // add to all roles with permissions
      getAllRolesWithPermissionsModel!.roles!.firstWhere((role) => role.id == roleId).permissions!.clear();
      getAllRolesWithPermissionsModel!.roles!
          .firstWhere((role) => role.id == roleId)
          .permissions!
          .addAll(allPermissionsList!.where((permission) => selectedRolePermissionsIds.contains(permission.id)));
      emit(AssignPermissionsToRoleSuccessState(assignPermissionsToRoleModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AssignPermissionsToRoleErrorState());
    });
  }

  AddEditRoleModel? addRoleModel;

  void addRole({required String roleName}) {
    emit(AddRoleLoadingState());
    DioHelper.postData(url: EndPointsConstants.roles, data: {"name": roleName}).then((value) {
      print(value?.data);
      addRoleModel = AddEditRoleModel.fromMap(value?.data);
      if (addRoleModel!.status == true) getAllRolesWithPermissionsModel!.roles!.add(addRoleModel!.role!);
      emit(AddRoleSuccessState(addRoleModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AddRoleErrorState());
    });
  }

  void onChangeRoleName(TextEditingController controller, String value) {
    controller.text = value;
    print(controller.text);
    emit(ChangeRoleNameState());
  }

  AddEditRoleModel? editRoleModel;

  void editRole({required int roleId, required String roleName}) {
    emit(EditRoleLoadingState());
    DioHelper.putData(url: '${EndPointsConstants.roles}/$roleId', data: {"name": roleName}).then((value) {
      print(value?.data);
      editRoleModel = AddEditRoleModel.fromMap(value?.data);
      if (editRoleModel!.status == true) getAllRolesWithPermissionsModel!.roles!.firstWhere((role) => role.id == roleId).name = roleName;
      emit(EditRoleSuccessState(editRoleModel!));
    }).catchError((error) {
      print(error.toString());
      emit(EditRoleErrorState());
    });
  }

  StatusMessageModel? deleteRoleModel;

  void deleteRole({required int roleId}) {
    emit(DeleteRoleLoadingState());
    DioHelper.deleteData(url: '${EndPointsConstants.roles}/$roleId').then((value) {
      print(value?.data);
      deleteRoleModel = StatusMessageModel.fromMap(value?.data);
      getAllRolesWithPermissionsModel!.roles!.removeWhere((role) => role.id == roleId);
      emit(DeleteRoleSuccessState(deleteRoleModel!));
    }).catchError((error) {
      print(error.toString());
      emit(DeleteRoleErrorState());
    });
  }
}
