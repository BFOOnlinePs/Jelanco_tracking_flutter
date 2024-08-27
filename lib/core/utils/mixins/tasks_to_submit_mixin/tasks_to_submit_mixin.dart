import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin TasksToSubmitMixin<T> on Cubit<T> {
  GetTasksModel? getTasksToSubmitModel;
  List<TaskModel> tasksAssignedToUserList = [];

  bool isTasksAssignedToUserLoading = false;
  bool isTasksAssignedToUserLastPage = false;


  Future<void> getTasksToSubmit({
    int page = 1,
    int? perPage = 5,
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    emit(loadingState);
    isTasksAssignedToUserLoading = true;

    await DioHelper.getData(
      url: EndPointsConstants.tasksToSubmit,
      query: {
        'per_page': perPage,
        'page': page
      },
    ).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        tasksAssignedToUserList.clear();
      }
      getTasksToSubmitModel = GetTasksModel.fromMap(value?.data);

      tasksAssignedToUserList
          .addAll(getTasksToSubmitModel?.tasks as Iterable<TaskModel>);

      print('tasksAssignedToUserList length: ${tasksAssignedToUserList.length}');

      isTasksAssignedToUserLastPage = getTasksToSubmitModel?.pagination?.lastPage ==
          getTasksToSubmitModel?.pagination?.currentPage;

      isTasksAssignedToUserLoading = false;
      emit(successState);
    }).catchError((error) {
      emit(errorState(error.toString()));
      print(error.toString());
    });
  }
}
