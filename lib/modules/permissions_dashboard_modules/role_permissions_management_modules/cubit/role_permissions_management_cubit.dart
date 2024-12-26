import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/system_permissions_mixin/system_permissions_mixin.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_all_roles_with_permissions_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class RolePermissionsManagementCubit extends Cubit<RolePermissionsManagementStates>
    with SystemPermissionsMixin<RolePermissionsManagementStates> {
  RolePermissionsManagementCubit() : super(RolePermissionsManagementInitialState());

  static RolePermissionsManagementCubit get(context) => BlocProvider.of(context);

  GetAllRolesWithPermissionsModel? getAllRolesWithPermissionsModel;

  void getAllRolesWithPermissions() {
    emit(GetAllRolesWithPermissionsLoadingState());
    DioHelper.getData(url: EndPointsConstants.rolesWithPermissions).then((value) {
      print(value?.data);
      getAllRolesWithPermissionsModel = GetAllRolesWithPermissionsModel.fromMap(value?.data);
      emit(GetAllRolesWithPermissionsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllRolesWithPermissionsErrorState());
    });
  }

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
      Future.delayed(const Duration(milliseconds: 1000),
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

  void assignPermissionsToRole({required int roleId, required List<int> selectedRolePermissionsIds}) {
    emit(AssignPermissionsToRoleLoadingState());
    DioHelper.postData(url: '${EndPointsConstants.roles}/$roleId/${EndPointsConstants.permissions}', data: {
      "permissionIds": selectedRolePermissionsIds
    }).then((value) {
      print(value?.data);
      emit(AssignPermissionsToRoleSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AssignPermissionsToRoleErrorState());
    });
  }
}
