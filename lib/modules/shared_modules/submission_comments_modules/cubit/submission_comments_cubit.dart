import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class SubmissionCommentsCubit extends Cubit<SubmissionCommentsStates> {
  SubmissionCommentsCubit() : super(SubmissionCommentsInitialState());

  static SubmissionCommentsCubit get(context) => BlocProvider.of(context);

  GetSubmissionCommentsModel? getSubmissionCommentsModel;

  Future<void> getSubmissionComments({required int submissionId}) async {
    emit(GetSubmissionCommentsLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionComments}', // /task-submissions/139/comments
    ).then((value) {
      print(value?.data);
      getSubmissionCommentsModel =
          GetSubmissionCommentsModel.fromMap(value?.data);
      emit(GetSubmissionCommentsSuccessState());
    }).catchError((error) {
      emit(GetSubmissionCommentsErrorState(error.toString()));
      print(error.toString());
    });
  }
}
