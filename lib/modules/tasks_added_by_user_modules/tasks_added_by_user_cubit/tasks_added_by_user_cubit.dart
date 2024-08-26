import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_added_by_user_model.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TasksAddedByUserCubit extends Cubit<TasksAddedByUserStates> {
  TasksAddedByUserCubit() : super(TasksAddedByUserInitialState());

  static TasksAddedByUserCubit get(context) => BlocProvider.of(context);

  // GetTasksAddedByUserErrorState

  GetTasksAddedByUserModel? getTasksAddedByUserModel;

  Future<void> getTasksAddedByUser() async {
    emit(GetTasksAddedByUserLoadingState());
    await DioHelper.getData(url: EndPointsConstants.tasksAddedByUser)
        .then((value) {
      print(value?.data);
      getTasksAddedByUserModel = GetTasksAddedByUserModel.fromMap(value?.data);
      emit(GetTasksAddedByUserSuccessState());
    }).catchError((error) {
      emit(GetTasksAddedByUserErrorState(error: error.toString()));
    });
  }
}
