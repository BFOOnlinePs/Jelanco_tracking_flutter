import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_today_submissions_model.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TodaySubmissionsCubit extends Cubit<TodaySubmissionsStates> {
  TodaySubmissionsCubit() : super(TodaySubmissionsInitialState());

  static TodaySubmissionsCubit get(context) => BlocProvider.of(context);

  GetTodaySubmissionsModel? getTodaySubmissionsModel;

  void getTodaySubmissions() {
    emit(GetTodaySubmissionsLoadingState());
    DioHelper.getData(url: EndPointsConstants.todaySubmissions).then((value) {
      print(value?.data);
      getTodaySubmissionsModel = GetTodaySubmissionsModel.fromMap(value?.data);
      emit(GetTodaySubmissionsSuccessState());
    }).catchError((error) {
      emit(GetTodaySubmissionsErrorState());
    });
  }
}
