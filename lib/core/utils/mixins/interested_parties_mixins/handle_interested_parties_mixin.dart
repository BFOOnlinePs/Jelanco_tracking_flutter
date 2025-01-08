import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin HandleInterestedPartiesMixin<T> on Cubit<T> {
  /// send as list
  void handleInterestedParties({
    required T loadingState,
    required T successState,
    required T errorState,
  }) {
    emit(loadingState);
    DioHelper.postData(
      url: EndPointsConstants.interestedParties,
      data: {},
    ).then((value) {
      print(value?.data);
      // model
      emit(successState);
    }).catchError((error) {
      print(error);
      emit(errorState);
    });
  }
}
