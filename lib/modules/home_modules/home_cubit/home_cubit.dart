import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/tasks_to_submit_mixin/tasks_to_submit_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comment_count_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_user_submissions_model.dart';
import 'package:jelanco_tracking_system/models/users_models/get_user_by_id_model.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> with TasksToSubmitMixin<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  GetUserSubmissionsModel? getUserSubmissionsModel;
  List<TaskSubmissionModel> userSubmissionsList = [];

  bool isUserSubmissionsLoading = false;
  bool isUserSubmissionsLastPage = false;

  // his submissions + his employees submission if he has any
  Future<void> getUserSubmissions({int page = 1}) async {
    emit(GetUserSubmissionsLoadingState());
    isUserSubmissionsLoading = true;
    await DioHelper.getData(
      url: EndPointsConstants.userSubmissions,
      query: {'page': page},
    ).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        userSubmissionsList.clear();
      }
      getUserSubmissionsModel = GetUserSubmissionsModel.fromMap(value?.data);

      userSubmissionsList.addAll(getUserSubmissionsModel?.submissions
          as Iterable<TaskSubmissionModel>);

      isUserSubmissionsLastPage =
          getUserSubmissionsModel?.pagination?.lastPage ==
              getUserSubmissionsModel?.pagination?.currentPage;

      isUserSubmissionsLoading = false;
      emit(GetUserSubmissionsSuccessState());
    }).catchError((error) {
      emit(GetUserSubmissionsErrorState(error.toString()));
    });
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
      userSubmissionsList
          .firstWhere((submission) => submission.tsId == submissionId)
          .commentsCount = getSubmissionCommentCountModel?.commentsCount;

      emit(GetCommentsCountSuccessState());
    }).catchError((error) {
      emit(GetCommentsCountErrorState());
      print(error.toString());
    });
  }

  Future<void> init({required int userId}) async {
    try {
      await getUserById(userId: userId);

      // After getUserById is done, call the other functions
      getUserSubmissions();
      getTasksToSubmit(
        perPage: 3,
        loadingState: GetTasksToSubmitLoadingState(),
        successState: GetTasksToSubmitSuccessState(),
        errorState: (error) => GetTasksToSubmitErrorState(error),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void afterEditSubmission({
    required int oldSubmissionId,
    required final TaskSubmissionModel newSubmissionModel,
  }) {
    // Replace the old submission with the new one
    // Find the index of the submission with the old ID
    int index = userSubmissionsList
        .indexWhere((submission) => submission.tsId == oldSubmissionId);

    if (index != -1) {
      // Replace the old submission with the new one
      userSubmissionsList[index] = newSubmissionModel;

      print(userSubmissionsList[index].toMap());
      print(userSubmissionsList[index].tsId);
    }
    emit(AfterEditSubmissionState());
  }

  GetUserByIdModel? getUserByIdModel;

  Future<void> getUserById({required int userId}) async {
    emit(GetUserByIdLoadingState());
    await DioHelper.getData(
      url: '${EndPointsConstants.users}/$userId',
    ).then((value) {
      print(value?.data);
      getUserByIdModel = GetUserByIdModel.fromMap(value?.data);

      UserDataConstants.userId = getUserByIdModel?.user?.id;
      UserDataConstants.name = getUserByIdModel?.user?.name;
      UserDataConstants.email = getUserByIdModel?.user?.email;
      UserDataConstants.image = getUserByIdModel?.user?.image;
      UserDataConstants.jobTitle = getUserByIdModel?.user?.jobTitle;

      //
      UserDataConstants.userModel = getUserByIdModel?.user;

      UserDataConstants.permissionsList =
          getUserByIdModel?.permissions?.map<String>((permission) {
        return permission.name ?? '';
      }).toList();

      emit(GetUserByIdSuccessState());
    }).catchError((error) {
      emit(GetUserByIdErrorState());
    });
  }

  @override
  Future<void> close() {
    print('userSubmissionsList: ${userSubmissionsList.length}');
    scrollController.dispose();
    getUserSubmissionsModel = null;

    return super.close();
  }
}
