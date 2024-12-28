import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/permission_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin SystemPermissionsMixin<T> on Cubit<T> {
  List<PermissionModel>? allPermissionsList;

  Future<void> getAllPermissions({required T loadingState, required T successState, required T errorState}) async {
    emit(loadingState);
    await DioHelper.getData(url: EndPointsConstants.permissions).then((value) {
      print(value?.data);
      if (value?.data != null) {
        allPermissionsList = [];
        allPermissionsList?.addAll(
          value!.data.map<PermissionModel>((permission) => PermissionModel.fromMap(permission)).toList(),
        );
      }
      emit(successState);
    }).catchError((error) {
      print(error.toString());
      emit(errorState);
    });
  }
}
