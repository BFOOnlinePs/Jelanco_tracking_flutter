import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';
import 'package:jelanco_tracking_system/models/permissions_management_models/add_update_permission_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/permissions_management_modules/cubit/permissions_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class PermissionsManagementCubit extends Cubit<PermissionsManagementStates> {
  PermissionsManagementCubit() : super(PermissionsManagementInitialState());

  static PermissionsManagementCubit get(context) => BlocProvider.of(context);

  List<PermissionModel> allPermissionsList = [];

  void getAllPermissions() {
    emit(GetAllPermissionsLoadingState());
    DioHelper.getData(url: EndPointsConstants.permissions).then((value) {
      print(value?.data);
      if (value?.data != null) {
        allPermissionsList.addAll(
          value!.data.map<PermissionModel>((permission) => PermissionModel.fromMap(permission)).toList(),
        );
      }
      emit(GetAllPermissionsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllPermissionsErrorState());
    });
  }

  void onChangePermissionName(TextEditingController controller, String value) {
    controller.text = value;
    print(controller.text);
    emit(ChangePermissionNameState());
  }

  AddUpdatePermissionModel? addPermissionModel;

  void addPermission({required String permissionName}) {
    emit(AddPermissionLoadingState());
    DioHelper.postData(url: EndPointsConstants.permissions, data: {'name': permissionName}).then((value) {
      print(value?.data);
      addPermissionModel = AddUpdatePermissionModel.fromMap(value?.data);
      emit(AddPermissionSuccessState(addPermissionModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AddPermissionErrorState());
    });
  }

  AddUpdatePermissionModel? updatePermissionModel;

  void updatePermission({required int permissionId, required String permissionName}) {
    emit(UpdatePermissionLoadingState());
    DioHelper.putData(
      url: '${EndPointsConstants.permissions}/$permissionId',
      data: {'name': permissionName},
    ).then((value) {
      print(value?.data);
      updatePermissionModel = AddUpdatePermissionModel.fromMap(value?.data);
      emit(UpdatePermissionSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdatePermissionErrorState());
    });
  }
}
