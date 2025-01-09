import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin HandleInterestedPartiesMixin<T> on Cubit<T> {
  StatusMessageModel? handleInterestedPartiesModel;

  /// send as list
  void handleInterestedParties({
    required String articleType,
    required int articleId,
    required List<int> interestedParties,
    required T loadingState,
    required T Function(StatusMessageModel statusMessageModel) successState,
    required T errorState,
  }) {
    emit(loadingState);
    print('interestedParties $interestedParties');

    DioHelper.postData(
      url: EndPointsConstants.interestedParties,
      data: {'article_type': articleType, 'article_id': articleId, 'interested_party_ids': interestedParties},
    ).then((value) {
      print(value?.data);
      handleInterestedPartiesModel = StatusMessageModel.fromMap(value?.data);
      emit(successState(handleInterestedPartiesModel!));
    }).catchError((error) {
      print(error);
      emit(errorState);
    });
  }
}
