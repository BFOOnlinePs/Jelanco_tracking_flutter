import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_added_by_user_model.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TasksAddedByUserCubit extends Cubit<TasksAddedByUserStates> {
  TasksAddedByUserCubit() : super(TasksAddedByUserInitialState());

  static TasksAddedByUserCubit get(context) => BlocProvider.of(context);

  // GetTasksAddedByUserErrorState

  GetTasksAddedByUserModel? getTasksAddedByUserModel;
  List<TaskModel> tasksAddedByUserList = [];

  bool isTasksAddedByUserLoading = false;
  bool isTasksAddedByUserLastPage = false;

  Future<void> getTasksAddedByUser({int page = 1}) async {
    emit(GetTasksAddedByUserLoadingState());
    isTasksAddedByUserLoading = true;
    await DioHelper.getData(
      url: EndPointsConstants.tasksAddedByUser,
      query: {'page': page},
    ).then((value) {
      print(value?.data);

      // when refresh
      if (page == 1) {
        tasksAddedByUserList.clear();
      }
      getTasksAddedByUserModel = GetTasksAddedByUserModel.fromMap(value?.data);

      tasksAddedByUserList.addAll(getTasksAddedByUserModel?.tasks as Iterable<TaskModel>);

      isTasksAddedByUserLastPage =
          getTasksAddedByUserModel?.pagination?.lastPage == getTasksAddedByUserModel?.pagination?.currentPage;

      isTasksAddedByUserLoading = false;

      emit(GetTasksAddedByUserSuccessState());
    }).catchError((error) {
      emit(GetTasksAddedByUserErrorState(error: error.toString()));
    });
  }

  void afterEditTask({
    required int oldTaskId,
    required final TaskModel newTaskModel,
  }) {
    // Replace the old task with the new one
    // Find the index of the task with the old ID
    int? index = tasksAddedByUserList.indexWhere((task) => task.tId == oldTaskId);
    print('tasksAddedByUserList[index!].toMap(): BEFORE EDIT');
    print(tasksAddedByUserList[index].toMap());
    if (index != -1) {
      print('index: $index');
      // Replace the old task with the new one
      tasksAddedByUserList[index] = newTaskModel;
      print('tasksAddedByUserList[index].toMap(): AFTER EDIT');
      print(tasksAddedByUserList[index].toMap());
    }
    emit(AfterEditTaskState());
  }
}
