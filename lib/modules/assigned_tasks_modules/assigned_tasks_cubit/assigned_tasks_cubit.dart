import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_tasks_assigned_to_user_model.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AssignedTasksCubit extends Cubit<AssignedTasksStates> {
  AssignedTasksCubit() : super(AssignedTasksInitialState());

  static AssignedTasksCubit get(context) => BlocProvider.of(context);

  GetTasksAssignedToUserModel? getTasksAssignedToUserModel;

  void getAssignedTasks() {
    emit(GetAssignedTasksLoadingState());
    DioHelper.getData(url: EndPointsConstants.tasksAssignedToUser)
        .then((value) {
      print(value?.data);
      getTasksAssignedToUserModel =
          GetTasksAssignedToUserModel.fromMap(value?.data);
      emit(GetAssignedTasksSuccessState());
    }).catchError((error) {
      emit(GetAssignedTasksErrorState(error: error.toString()));
      print(error.toString());
    });
  }
}
