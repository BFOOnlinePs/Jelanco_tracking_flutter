import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/role_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/get_all_roles_with_permissions_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/role_permissions_management_modules/cubit/role_permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class RolePermissionsManagementCubit extends Cubit<RolePermissionsManagementStates> {
  RolePermissionsManagementCubit() : super(RolePermissionsManagementInitialState());

  static RolePermissionsManagementCubit get(context) => BlocProvider.of(context);

  // List<RoleModel> allRolesList = [];
  //
  // void getAllRoles() {
  //   emit(GetAllRolesLoadingState());
  //   DioHelper.getData(url: EndPointsConstants.roles).then((value) {
  //     print(value?.data);
  //     if (value?.data != null) {
  //       allRolesList.addAll(value!.data.map<RoleModel>((role) => RoleModel.fromMap(role)).toList());
  //     }
  //
  //     emit(GetAllRolesSuccessState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(GetAllRolesErrorState());
  //   });
  // }

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
    if (index == expandedIndex) index = -1;
    expandedIndex = index;
    emit(SetExpandedIndexState());
  }
}
