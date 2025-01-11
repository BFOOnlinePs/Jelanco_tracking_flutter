import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/interested_parties_models/get_articles_of_interest_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin GetArticlesOfInterestMixin<T> on Cubit<T> {
  GetArticlesOfInterestModel? getTasksOfInterestModel;
  GetArticlesOfInterestModel? getSubmissionsOfInterestModel;

  Future<void> getArticlesOfInterest({
    required int interestedPartyId,
    required String articleType,
    required T loadingState,
    required T successState,
    required T errorState,
  }) async {
    emit(loadingState);
    DioHelper.postData(
      url: '${EndPointsConstants.interestedParties}/${EndPointsConstants.articles}',
      data: {'interested_party_id': interestedPartyId, 'article_type': articleType},
    ).then((value) {
      print(value?.data);
      if (articleType == 'task') {
        getTasksOfInterestModel = GetArticlesOfInterestModel.fromMap(value?.data);
      } else if (articleType == 'submission') {
        getSubmissionsOfInterestModel = GetArticlesOfInterestModel.fromMap(value?.data);
      } else {
        emit(errorState);
      }
      emit(successState);
    }).catchError((error) {
      emit(errorState);
      print(error.toString());
    });
  }
}
