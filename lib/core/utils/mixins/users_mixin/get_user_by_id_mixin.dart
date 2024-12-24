import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/users_models/get_user_by_id_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin GetUserByIdMixin<T> on Cubit<T> {
  GetUserByIdModel? getUserByIdModel;

  Future<void> getUserById({required int userId, required T loadingState, required T successState, required T errorState}) async {
    emit(loadingState);
    await DioHelper.getData(
      url: '${EndPointsConstants.users}/$userId',
    ).then((value) {
      print(value?.data);
      getUserByIdModel = GetUserByIdModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      print(error.toString());
      emit(errorState);
    });
  }
}
