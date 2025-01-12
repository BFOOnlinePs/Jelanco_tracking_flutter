import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_cubit.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_states.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/widgets/article_item.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

class ArticlesOfInterestTabBody extends StatelessWidget {
  final bool isTask;
  final int interestedPartyId;

  ArticlesOfInterestTabBody({super.key, required this.isTask, required this.interestedPartyId});

  late ArticlesOfInterestCubit articlesOfInterestCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticlesOfInterestCubit, ArticlesOfInterestStates>(
      listener: (context, state) {},
      builder: (context, state) {
        articlesOfInterestCubit = ArticlesOfInterestCubit.get(context);
        return Container(
          margin: EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Column(
            children: [
              isTask
                  ? Text('تعرض هذه الصفحة قائمة بالمهام التي تمت الإشارة إليك فيها.')
                  : Text('تعرض هذه الصفحة قائمة بالتكليفات التي تمت الإشارة إليك فيها.'),
              Expanded(
                  child: isTask
                      ? articlesOfInterestCubit.getTasksOfInterestModel == null
                          ? const Center(child: MyLoader())
                          : MyRefreshIndicator(
                              onRefresh: () async {
                                await articlesOfInterestCubit.getArticlesOfInterest(
                                  interestedPartyId: interestedPartyId,
                                  articleType: 'task',
                                  loadingState: GetArticlesOfInterestLoadingState(),
                                  successState: GetArticlesOfInterestSuccessState(),
                                  errorState: GetArticlesOfInterestErrorState(),
                                );
                              },
                              child: ListView.builder(
                                itemCount: articlesOfInterestCubit.tasksOfInterestList.length +
                                    (articlesOfInterestCubit.isTasksOfInterestLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index == articlesOfInterestCubit.tasksOfInterestList.length &&
                                      !articlesOfInterestCubit.isTasksOfInterestLastPage) {
                                    if (!articlesOfInterestCubit.isTasksOfInterestLoading) {
                                      articlesOfInterestCubit.getArticlesOfInterest(
                                          interestedPartyId: interestedPartyId,
                                          articleType: 'task',
                                          page: articlesOfInterestCubit.getTasksOfInterestModel!.pagination!.currentPage! + 1,
                                          loadingState: GetArticlesOfInterestLoadingState(),
                                          successState: GetArticlesOfInterestSuccessState(),
                                          errorState: GetArticlesOfInterestErrorState());
                                    }
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: MyLoader()),
                                    );
                                  }
                                  return ArticleItem(
                                    isTask: isTask,
                                    interestedPartyModel: articlesOfInterestCubit.tasksOfInterestList[index],
                                  );
                                },
                              ),
                            )
                      : articlesOfInterestCubit.getSubmissionsOfInterestModel == null
                          ? const Center(child: MyLoader())
                          : MyRefreshIndicator(
                              onRefresh: () async {
                                await articlesOfInterestCubit.getArticlesOfInterest(
                                  interestedPartyId: interestedPartyId,
                                  articleType: 'submission',
                                  loadingState: GetArticlesOfInterestLoadingState(),
                                  successState: GetArticlesOfInterestSuccessState(),
                                  errorState: GetArticlesOfInterestErrorState(),
                                );
                              },
                              child: ListView.builder(
                                itemCount: articlesOfInterestCubit.submissionsOfInterestList.length +
                                    (articlesOfInterestCubit.isSubmissionsOfInterestLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index == articlesOfInterestCubit.submissionsOfInterestList.length &&
                                      !articlesOfInterestCubit.isSubmissionsOfInterestLastPage) {
                                    if (!articlesOfInterestCubit.isSubmissionsOfInterestLoading) {
                                      articlesOfInterestCubit.getArticlesOfInterest(
                                          interestedPartyId: interestedPartyId,
                                          articleType: 'submission',
                                          page: articlesOfInterestCubit.getSubmissionsOfInterestModel!.pagination!.currentPage! + 1,
                                          loadingState: GetArticlesOfInterestLoadingState(),
                                          successState: GetArticlesOfInterestSuccessState(),
                                          errorState: GetArticlesOfInterestErrorState());
                                    }
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: MyLoader()),
                                    );
                                  }
                                  return ArticleItem(
                                    isTask: isTask,
                                    interestedPartyModel: articlesOfInterestCubit.submissionsOfInterestList[index],
                                  );
                                },
                              ),
                            )

                  // articlesOfInterestCubit.getTasksOfInterestModel == null || articlesOfInterestCubit.getSubmissionsOfInterestModel == null
                  //     ? const Center(child: MyLoader())
                  //     : ListView.builder(
                  //         itemCount: isTask
                  //             ? articlesOfInterestCubit.getTasksOfInterestModel?.articlesOfInterest?.length
                  //             : articlesOfInterestCubit.getSubmissionsOfInterestModel?.articlesOfInterest?.length,
                  //         itemBuilder: (context, index) {
                  //           return ArticleItem(
                  //             isTask: isTask,
                  //             interestedPartyModel: isTask
                  //                 ? articlesOfInterestCubit.getTasksOfInterestModel!.articlesOfInterest![index]
                  //                 : articlesOfInterestCubit.getSubmissionsOfInterestModel!.articlesOfInterest![index],
                  //           );
                  //         },
                  //       ),
                  )
            ],
          ),
        );
      },
    );
  }
}
