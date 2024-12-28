import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/role_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin SystemRolesMixin<T> on Cubit<T> {
  List<RoleModel>? allRolesList;

  Future<void> getAllRoles({required T loadingState, required T successState, required T errorState}) async {
    emit(loadingState);
    await DioHelper.getData(url: EndPointsConstants.roles).then((value) {
      print(value?.data);
      if (value?.data != null) {
        allRolesList = [];
        allRolesList?.addAll(value!.data.map<RoleModel>((role) => RoleModel.fromMap(role)).toList());
      }
      emit(successState);
    }).catchError((error) {
      print(error.toString());
      emit(errorState);
    });
  }
}
