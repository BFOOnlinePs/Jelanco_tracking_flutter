import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/tasks_to_submit_mixin/tasks_to_submit_mixin.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_user_submissions_model.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_screen.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_screen.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> with TasksToSubmitMixin<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  GetUserSubmissionsModel? getUserSubmissionsModel;

  Future<void> getUserSubmissions() async {
    emit(GetUserSubmissionsLoadingState());
    await DioHelper.getData(
      url: EndPointsConstants.userSubmissions,
    ).then((value) {
      print(value?.data);
      getUserSubmissionsModel = GetUserSubmissionsModel.fromMap(value?.data);
      emit(GetUserSubmissionsSuccessState());
    }).catchError((error) {
      emit(GetUserSubmissionsErrorState(error.toString()));
    });
  }
}
