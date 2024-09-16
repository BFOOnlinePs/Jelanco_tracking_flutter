import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/manager_employees_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin ManagerEmployeesMixin<T> on Cubit<T> {
  GetManagerEmployeesModel? getManagerEmployeesModel;

  Future<void> getManagerEmployees({
    required T loadingState,
    required T successState,
    required T errorState,
  }) async {
    emit(loadingState);
    await DioHelper.getData(
      url: EndPointsConstants.managerEmployees,
    ).then((value) {
      print(value?.data);
      getManagerEmployeesModel = GetManagerEmployeesModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      emit(errorState);
      print(error.toString());
    });
  }
}
