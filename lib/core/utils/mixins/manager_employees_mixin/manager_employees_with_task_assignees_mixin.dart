import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/manager_employees_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin ManagerEmployeesWithTaskAssigneesMixin<T> on Cubit<T> {
  GetManagerEmployeesModel? getManagerEmployeesWithTaskAssigneesModel;

  Future<void> getManagerEmployeesWithTaskAssignees({
    required int taskId,
    required T loadingState,
    required T successState,
    required T errorState,
  }) async {
    emit(loadingState);
    await DioHelper.postData(
        url: EndPointsConstants.managerEmployeesWithTaskAssignees,
        data: {'task_id': taskId}).then((value) {
      print(value?.data);
      getManagerEmployeesWithTaskAssigneesModel =
          GetManagerEmployeesModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      emit(errorState);
      print(error.toString());
    });
  }
}
