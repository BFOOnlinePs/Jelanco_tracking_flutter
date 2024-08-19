import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_user_submissions_model.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  GetUserSubmissionsModel? getUserSubmissionsModel;

  void getUserSubmissions() {
    emit(GetUserSubmissionsLoadingState());
    DioHelper.getData(
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
