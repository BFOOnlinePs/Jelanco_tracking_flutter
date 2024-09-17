import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comment_count_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_today_submissions_model.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TodaySubmissionsCubit extends Cubit<TodaySubmissionsStates> {
  TodaySubmissionsCubit() : super(TodaySubmissionsInitialState());

  static TodaySubmissionsCubit get(context) => BlocProvider.of(context);

  GetTodaySubmissionsModel? getTodaySubmissionsModel;
  List<TaskSubmissionModel> todaySubmissionsList = [];

  bool isTodaySubmissionsLoading = false;
  bool isTodaySubmissionsLastPage = false;

  Future<void> getTodaySubmissions({int page = 1}) async {
    emit(GetTodaySubmissionsLoadingState());
    isTodaySubmissionsLoading = true;
    await DioHelper.getData(
      url: EndPointsConstants.todaySubmissions,
      query: {'page': page},
    ).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        todaySubmissionsList.clear();
      }
      getTodaySubmissionsModel = GetTodaySubmissionsModel.fromMap(value?.data);
      todaySubmissionsList.addAll(getTodaySubmissionsModel?.submissions
          as Iterable<TaskSubmissionModel>);
      isTodaySubmissionsLastPage =
          getTodaySubmissionsModel?.pagination?.lastPage ==
              getTodaySubmissionsModel?.pagination?.currentPage;
      isTodaySubmissionsLoading = false;
      emit(GetTodaySubmissionsSuccessState());
    }).catchError((error) {
      emit(GetTodaySubmissionsErrorState());
    });
  }

  void afterEditSubmission({
    required int oldSubmissionId,
    required final TaskSubmissionModel newSubmissionModel,
  }) {
    // Replace the old submission with the new one
    // Find the index of the submission with the old ID
    int index = todaySubmissionsList
        .indexWhere((submission) => submission.tsId == oldSubmissionId);

    if (index != -1) {
      // Replace the old submission with the new one
      todaySubmissionsList[index] = newSubmissionModel;

      print(todaySubmissionsList[index].toMap());
      print(todaySubmissionsList[index].tsId);
    }
    emit(AfterEditSubmissionState());
  }

  GetSubmissionCommentCountModel? getSubmissionCommentCountModel;

  // after pop from submission comments screen, update the number of comments
  void getCommentsCount({required int submissionId}) async {
    emit(GetCommentsCountLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionComments}/${EndPointsConstants.taskSubmissionCommentsCount}',
      // /task-submissions/185/comments/count
    ).then((value) {
      print(value?.data);
      getSubmissionCommentCountModel =
          GetSubmissionCommentCountModel.fromMap(value?.data);
      // update the number of comments in the original submission model
      todaySubmissionsList
          .firstWhere((submission) => submission.tsId == submissionId)
          .commentsCount = getSubmissionCommentCountModel?.commentsCount;

      emit(GetCommentsCountSuccessState());
    }).catchError((error) {
      emit(GetCommentsCountErrorState());
      print(error.toString());
    });
  }
}
