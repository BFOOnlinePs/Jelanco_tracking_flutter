import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_with_submissions_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsStates> {
  TaskDetailsCubit() : super(TaskDetailsInitialState());

  static TaskDetailsCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  GetTaskWithSubmissionsAndCommentsModel?
      getTaskWithSubmissionsAndCommentsModel;

  Future<void> getTaskWithSubmissionsAndComments({required int taskId}) async {
    emit(TaskDetailsLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.tasks}/$taskId/${EndPointsConstants.tasksWithSubmissionsAndComments}',
    ).then((value) async {
      print(value?.data);
      getTaskWithSubmissionsAndCommentsModel =
          GetTaskWithSubmissionsAndCommentsModel.fromMap(value?.data);

      emit(TaskDetailsSuccessState());
    }).catchError((error) {
      emit(TaskDetailsErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
