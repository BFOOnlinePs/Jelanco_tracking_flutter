import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/users_models/get_all_users_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin UsersMixin<T> on Cubit<T> {
  GetAllUsersModel? getAllUsersModel;

  Future<void> getAllUsers({
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    emit(loadingState);
    await DioHelper.getData(url: EndPointsConstants.users).then((value) {
      print(value?.data);
      getAllUsersModel = GetAllUsersModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      emit(errorState(error.toString()));
      print(error.toString());
    });
  }
}
