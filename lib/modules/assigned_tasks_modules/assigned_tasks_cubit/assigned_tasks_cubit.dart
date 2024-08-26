import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_assigned_to_user_model.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AssignedTasksCubit extends Cubit<AssignedTasksStates> {
  AssignedTasksCubit() : super(AssignedTasksInitialState());

  static AssignedTasksCubit get(context) => BlocProvider.of(context);

  GetTasksAssignedToUserModel? getTasksAssignedToUserModel;
  List<TaskModel> tasksAddedByUserList = [];

  bool isTasksAddedByUserLoading = false;
  bool isTasksAddedByUserLastPage = false;

  Future<void> getAssignedTasks({int page = 1}) async {
    emit(GetAssignedTasksLoadingState());
    isTasksAddedByUserLoading = true;
    await DioHelper.getData(
      url: EndPointsConstants.tasksAssignedToUser,
      query: {'page': page},
    ).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        tasksAddedByUserList.clear();
      }
      getTasksAssignedToUserModel =
          GetTasksAssignedToUserModel.fromMap(value?.data);

      tasksAddedByUserList
          .addAll(getTasksAssignedToUserModel?.tasks as Iterable<TaskModel>);

      isTasksAddedByUserLastPage = getTasksAssignedToUserModel?.pagination?.lastPage ==
          getTasksAssignedToUserModel?.pagination?.currentPage;

      isTasksAddedByUserLoading = false;
      emit(GetAssignedTasksSuccessState());
    }).catchError((error) {
      emit(GetAssignedTasksErrorState(error: error.toString()));
      print(error.toString());
    });
  }
}
