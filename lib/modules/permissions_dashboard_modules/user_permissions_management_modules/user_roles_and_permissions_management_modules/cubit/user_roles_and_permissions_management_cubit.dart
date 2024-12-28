import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_user_role_and_permissions_ids_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/cubit/user_roles_and_permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class UserRolesAndPermissionsManagementCubit extends Cubit<UserRolesAndPermissionsManagementStates> {
  UserRolesAndPermissionsManagementCubit() : super(UserRolesAndPermissionsManagementInitialState());

  static UserRolesAndPermissionsManagementCubit get(context) => BlocProvider.of(context);

  GetUserRoleAndPermissionsIdsModel? getUserRoleAndPermissionIdsModel;

  void getUserRoleAndPermissionIds({required int userId}) async {
    emit(UserRolesAndPermissionsManagementLoadingState());
    DioHelper.getData(url: '${EndPointsConstants.users}/$userId/${EndPointsConstants.userRolesAndPermissions}').then((value) {
      print(value?.data);
      getUserRoleAndPermissionIdsModel = GetUserRoleAndPermissionsIdsModel.fromMap(value?.data);
      emit(UserRolesAndPermissionsManagementSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UserRolesAndPermissionsManagementErrorState());
    });
  }

  void toggleRoleSelection(int roleId) {
    if (getUserRoleAndPermissionIdsModel?.roleIds?.contains(roleId) ?? false) {
      getUserRoleAndPermissionIdsModel?.roleIds?.remove(roleId);
    } else {
      getUserRoleAndPermissionIdsModel?.roleIds?.add(roleId);
    }
    emit(ToggleRoleSelectionState());
  }

  void togglePermissionSelection(int permissionId) {
    if (getUserRoleAndPermissionIdsModel?.directPermissionIds?.contains(permissionId) ?? false) {
      getUserRoleAndPermissionIdsModel?.directPermissionIds?.remove(permissionId);
    } else {
      getUserRoleAndPermissionIdsModel?.directPermissionIds?.add(permissionId);
    }
    emit(TogglePermissionSelectionState());
  }
}
