import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin TasksToSubmitMixin<T> on Cubit<T> {
  GetTasksModel? getTasksToSubmitModel;

  Future<void> getTasksToSubmit({
    int? perPage = 10,
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    emit(loadingState);
    await DioHelper.getData(
      url: EndPointsConstants.tasksToSubmit,
      query: {
        'per_page': perPage,
      },
    ).then((value) {
      print(value?.data);
      getTasksToSubmitModel = GetTasksModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      emit(errorState(error.toString()));
      print(error.toString());
    });
  }
}
