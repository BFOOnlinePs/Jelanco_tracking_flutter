import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_task_submission_versions_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_cubit/task_submission_versions_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TaskSubmissionVersionsCubit extends Cubit<TaskSubmissionVersionsStates> {
  TaskSubmissionVersionsCubit() : super(TaskSubmissionVersionsInitialState());

  static TaskSubmissionVersionsCubit get(context) => BlocProvider.of(context);

  GetTaskSubmissionVersionsModel? getTaskSubmissionVersionsModel;

  void getTaskSubmissionVersions({required int taskSubmissionId}) {
    emit(GetTaskSubmissionVersionsLoadingState());
    DioHelper.getData(
            url:
                '${EndPointsConstants.taskSubmissions}/$taskSubmissionId/${EndPointsConstants.taskSubmissionVersions}')
        .then((value) {
      print(value?.data);
      getTaskSubmissionVersionsModel =
          GetTaskSubmissionVersionsModel.fromMap(value?.data);

      emit(GetTaskSubmissionVersionsSuccessState());
    }).catchError((error) {
      emit(GetTaskSubmissionVersionsErrorState(error: error.toString()));
      print(error.toString());
    });
  }
}
