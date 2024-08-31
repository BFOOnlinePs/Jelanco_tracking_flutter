import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/tasks_to_submit_mixin/tasks_to_submit_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_user_submissions_model.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_screen.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_screen.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> with TasksToSubmitMixin<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  GetUserSubmissionsModel? getUserSubmissionsModel;
  List<TaskSubmissionModel> userSubmissionsList = [];

  bool isUserSubmissionsLoading = false;
  bool isUserSubmissionsLastPage = false;

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

  void afterEditSubmission({
    required int oldSubmissionId,
    required final TaskSubmissionModel newSubmissionModel,
  }) {
    // no need for action
    // just edit the original model with the new data
    // print('submissionModel: ${oldSubmissionModel.toMap()}');
    print('editedSubmissionModel: ${newSubmissionModel.toMap()}');

    // submissionModel.tsContent = editedSubmissionModel.tsContent;
    // replace the old model with the new one

// Replace the old submission with the new one
    userSubmissionsList = userSubmissionsList.map((submission) {
      return submission.tsId == oldSubmissionId
          ? newSubmissionModel
          : submission;
    }).toList();

    // oldSubmissionModel = newSubmissionModel;
    // emit

    // print('submissionModel: ${oldSubmissionModel.toMap()}');
    print('editedSubmissionModel: ${newSubmissionModel.toMap()}');
    print('تعديل');

    emit(AfterEditSubmissionState());
  }
}
