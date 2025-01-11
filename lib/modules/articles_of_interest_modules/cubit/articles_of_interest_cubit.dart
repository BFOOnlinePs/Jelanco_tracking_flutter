import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/interested_parties_mixins/get_articles_of_interest_mixin.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_states.dart';

class ArticlesOfInterestCubit extends Cubit<ArticlesOfInterestStates> with GetArticlesOfInterestMixin<ArticlesOfInterestStates> {
  ArticlesOfInterestCubit() : super(InterestedArticlesInitialState());

  static ArticlesOfInterestCubit get(context) => BlocProvider.of(context);

  void init({required int interestedPartyId}) async {
    await Future.wait([
      getArticlesOfInterest(
        interestedPartyId: interestedPartyId,
        articleType: 'task',
        loadingState: GetArticlesOfInterestLoadingState(),
        successState: GetArticlesOfInterestSuccessState(),
        errorState: GetArticlesOfInterestErrorState(),
      ),
      getArticlesOfInterest(
        interestedPartyId: interestedPartyId,
        articleType: 'submission',
        loadingState: GetArticlesOfInterestLoadingState(),
        successState: GetArticlesOfInterestSuccessState(),
        errorState: GetArticlesOfInterestErrorState(),
      ),
    ]);


  }
}
