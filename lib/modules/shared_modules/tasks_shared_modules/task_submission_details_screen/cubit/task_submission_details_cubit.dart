import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_task_submission_with_task_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TaskSubmissionDetailsCubit extends Cubit<TaskSubmissionDetailsStates> {
  TaskSubmissionDetailsCubit() : super(TaskSubmissionDetailsInitialState());

  static TaskSubmissionDetailsCubit get(context) => BlocProvider.of(context);

  GetTaskSubmissionWithTaskAndCommentsModel?
      getTaskSubmissionWithTaskAndCommentsModel;

  void getTaskSubmissionWithTaskAndComments({required int submissionId}) {
    emit(GetTaskSubmissionWithTaskAndCommentsLoadingState());
    // /task-submissions/201/task-and-comments
    DioHelper.getData(
            url:
                '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionWithTaskAndComments}')
        .then((value) {
      print(value?.data);
      getTaskSubmissionWithTaskAndCommentsModel =
          GetTaskSubmissionWithTaskAndCommentsModel.fromMap(value?.data);
      emit(GetTaskSubmissionWithTaskAndCommentsSuccessState());
    }).catchError((error) {
      emit(GetTaskSubmissionWithTaskAndCommentsErrorState());
      print(error.toString());
    });
  }
}
