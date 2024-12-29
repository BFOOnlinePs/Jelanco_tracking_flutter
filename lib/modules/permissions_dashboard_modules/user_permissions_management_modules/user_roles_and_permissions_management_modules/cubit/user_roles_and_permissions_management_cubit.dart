import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_all_roles_with_permissions_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_user_role_and_permissions_ids_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/cubit/user_roles_and_permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class UserRolesAndPermissionsManagementCubit extends Cubit<UserRolesAndPermissionsManagementStates> {
  UserRolesAndPermissionsManagementCubit() : super(UserRolesAndPermissionsManagementInitialState());

  static UserRolesAndPermissionsManagementCubit get(context) => BlocProvider.of(context);

  /// from the previous screen/cubit
  List<PermissionModel>? allPermissions = [];
  GetAllRolesWithPermissionsModel? getAllRolesWithPermissionsModel;

  void init({
    required int userId,
    required List<PermissionModel>? allPermissions,
    required GetAllRolesWithPermissionsModel? getAllRolesWithPermissionsModel,
  }) async {
    this.allPermissions = allPermissions;
    this.getAllRolesWithPermissionsModel = getAllRolesWithPermissionsModel;
    await getUserRoleAndPermissionIds(userId: userId);
    hidePermissionsOfSelectedRoles();
  }

  GetUserRoleAndPermissionsIdsModel? getUserRoleAndPermissionIdsModel;

  Future<void> getUserRoleAndPermissionIds({required int userId}) async {
    emit(UserRolesAndPermissionsManagementLoadingState());
    await DioHelper.getData(url: '${EndPointsConstants.users}/$userId/${EndPointsConstants.userRolesAndPermissions}').then((value) {
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
    hidePermissionsOfSelectedRoles();

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

  StatusMessageModel? assignRolesToUserModel;

  void assignRolesToUser({required int userId, required List<int> roleIds}) async {
    emit(AssignRolesToUserLoadingState());
    DioHelper.postData(
      url: '${EndPointsConstants.users}/$userId/${EndPointsConstants.roles}',
      data: {'role_ids': roleIds},
    ).then((value) {
      print(value?.data);
      assignRolesToUserModel = StatusMessageModel.fromMap(value?.data);
      emit(AssignRolesToUserSuccessState(assignRolesToUserModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AssignRolesToUserErrorState());
    });
  }

  StatusMessageModel? assignPermissionsToUserModel;

  void assignPermissionsToUser({required int userId, required List<int> permissionIds}) async {
    emit(AssignPermissionsToUserLoadingState());
    DioHelper.postData(
      url: '${EndPointsConstants.users}/$userId/${EndPointsConstants.permissions}',
      data: {'permission_ids': permissionIds},
    ).then((value) {
      print(value?.data);
      assignPermissionsToUserModel = StatusMessageModel.fromMap(value?.data);
      emit(AssignPermissionsToUserSuccessState(assignPermissionsToUserModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AssignPermissionsToUserErrorState());
    });
  }

  // List<int> hiddenPermissionsIds = [];
  List<PermissionModel> visiblePermissions = [];

  void hidePermissionsOfSelectedRoles() {
    // filter the visible permissions, it shows allPermissions expect the permissions of the selected roles

    visiblePermissions = allPermissions?.where((permission) {
          print('this permissions 0');

          if (getUserRoleAndPermissionIdsModel?.roleIds != null) {
            print('this permissions 1');
            for (var roleId in getUserRoleAndPermissionIdsModel!.roleIds!) {
              if (getAllRolesWithPermissionsModel!.roles!.where((role) => role.id == roleId).isNotEmpty) {
                print('this permissions 2');

                for (var rolePermission in getAllRolesWithPermissionsModel!.roles!.where((role) => role.id == roleId).first.permissions!) {
                  print('this permissions 3');

                  if (rolePermission.id == permission.id) {
                    print('this permissions hide');
                    return false;
                  }
                }
              }
            }
          }
          print('this permissions show');
          return true;
        }).toList() ??
        [];
    emit(ExcludePermissionsOfSelectedRolesState());
  }
}
