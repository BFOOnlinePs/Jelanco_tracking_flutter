import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_states.dart';
import 'package:jelanco_tracking_system/models/users_models/get_all_users_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin UsersMixin<T> on Cubit<T> {
  GetAllUsersModel? getAllUsersModel;

  void getAllUsers() {
    emit(GetAllUsersLoadingState() as T);
    DioHelper.getData(url: EndPointsConstants.users).then((value) {
      print(value?.data);
      getAllUsersModel = GetAllUsersModel.fromMap(value?.data);
      emit(GetAllUsersSuccessState() as T);
    }).catchError((error) {
      emit(GetAllUsersErrorState(error: error.toString()) as T);
      print(error.toString());
    });
  }
}
