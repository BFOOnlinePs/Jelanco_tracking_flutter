import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/interested_party_model.dart';
import 'package:jelanco_tracking_system/models/interested_parties_models/get_articles_of_interest_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin GetArticlesOfInterestMixin<T> on Cubit<T> {
  GetArticlesOfInterestModel? getTasksOfInterestModel;
  GetArticlesOfInterestModel? getSubmissionsOfInterestModel;

  List<InterestedPartyModel> tasksOfInterestList = [];
  List<InterestedPartyModel> submissionsOfInterestList = [];

  bool isTasksOfInterestLoading = false;
  bool isTasksOfInterestLastPage = false;

  bool isSubmissionsOfInterestLoading = false;
  bool isSubmissionsOfInterestLastPage = false;

  Future<void> getArticlesOfInterest({
    int page = 1,
    required int interestedPartyId,
    required String articleType,
    required T loadingState,
    required T successState,
    required T errorState,
  }) async {
    emit(loadingState);
    if (articleType == 'task') {
      isTasksOfInterestLoading = true;
    } else if (articleType == 'submission') {
      isSubmissionsOfInterestLoading = true;
    }

    DioHelper.postData(
      url: '${EndPointsConstants.interestedParties}/${EndPointsConstants.articles}',
      data: {'interested_party_id': interestedPartyId, 'article_type': articleType},
      query: {'page': page},
    ).then((value) {
      print(value?.data);

      if (articleType == 'task') {
        // when refresh
        if (page == 1) {
          tasksOfInterestList.clear();
        }
        getTasksOfInterestModel = GetArticlesOfInterestModel.fromMap(value?.data);
        tasksOfInterestList.addAll(getTasksOfInterestModel?.articlesOfInterest as Iterable<InterestedPartyModel>);

        isTasksOfInterestLastPage = getTasksOfInterestModel?.pagination?.lastPage == getTasksOfInterestModel?.pagination?.currentPage;

        isTasksOfInterestLoading = false;
      } else if (articleType == 'submission') {
        // when refresh
        if (page == 1) {
          submissionsOfInterestList.clear();
        }
        getSubmissionsOfInterestModel = GetArticlesOfInterestModel.fromMap(value?.data);
        submissionsOfInterestList.addAll(getSubmissionsOfInterestModel?.articlesOfInterest as Iterable<InterestedPartyModel>);

        isSubmissionsOfInterestLastPage =
            getSubmissionsOfInterestModel?.pagination?.lastPage == getSubmissionsOfInterestModel?.pagination?.currentPage;

        isSubmissionsOfInterestLoading = false;
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
