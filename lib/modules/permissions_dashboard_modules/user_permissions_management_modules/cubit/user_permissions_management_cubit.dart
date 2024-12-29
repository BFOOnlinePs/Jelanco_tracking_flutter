import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/system_permissions_mixin/system_permissions_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/system_roles_mixin/system_roles_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';

class UserPermissionsManagementCubit extends Cubit<UserPermissionsManagementStates>
    with
        UsersMixin<UserPermissionsManagementStates>,
        SystemPermissionsMixin<UserPermissionsManagementStates>,
        SystemRolesMixin<UserPermissionsManagementStates> {
  UserPermissionsManagementCubit() : super(UserPermissionsManagementInitialState());

  static UserPermissionsManagementCubit get(context) => BlocProvider.of(context);

  TextEditingController searchController = TextEditingController();


  void getInitialData() async {
    await Future.wait([
      getAllPermissions(
          loadingState: GetAllPermissionsLoadingState(),
          successState: GetAllPermissionsSuccessState(),
          errorState: GetAllPermissionsErrorState()),
      getAllRolesWithPermissions(loadingState: GetAllRolesWithPermissionsLoadingState(), successState: GetAllRolesWithPermissionsSuccessState(), errorState: GetAllRolesWithPermissionsErrorState()),
      getAllUsers(
        pagination: 1,
        isRole: 1,
        loadingState: GetAllUsersLoadingState(),
        successState: GetAllUsersSuccessState(),
        errorState: (error) => GetAllUsersErrorState(),
      )
    ]);
  }
}
