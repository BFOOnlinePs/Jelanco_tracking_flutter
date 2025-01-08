import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/interested_parties_models/get_interested_parties_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin GetInterestedPartiesMixin<T> on Cubit<T> {
  GetInterestedPartiesModel? getInterestedPartiesModel;

  Future<void> getInterestedParties({
    required String articleType,
    required int articleId,
    required T loadingState,
    required T successState,
    required T errorState,
  }) async {
    emit(loadingState);
    await DioHelper.getData(
      url: EndPointsConstants.interestedParties,
      query: {'article_type': articleType, 'article_id': articleId},
    ).then((value) {
      print(value?.data);
      getInterestedPartiesModel = GetInterestedPartiesModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      emit(errorState);
      print(error.toString());
    });
  }
}
