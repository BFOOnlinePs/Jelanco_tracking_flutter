import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_cubit.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_states.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/widgets/article_item.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';

class ArticlesOfInterestTabBody extends StatelessWidget {
  final bool isTask;

  ArticlesOfInterestTabBody({super.key, required this.isTask});

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

              // todo pagination
              Expanded(
                  child: articlesOfInterestCubit.getTasksOfInterestModel == null ||
                          articlesOfInterestCubit.getSubmissionsOfInterestModel == null
                      ? const Center(child: MyLoader())
                      : ListView.builder(
                          itemCount: isTask
                              ? articlesOfInterestCubit.getTasksOfInterestModel?.articlesOfInterest?.length
                              : articlesOfInterestCubit.getSubmissionsOfInterestModel?.articlesOfInterest?.length,
                          itemBuilder: (context, index) {
                            return ArticleItem(
                              isTask: isTask,
                              interestedPartyModel: isTask
                                  ? articlesOfInterestCubit.getTasksOfInterestModel!.articlesOfInterest![index]
                                  : articlesOfInterestCubit.getSubmissionsOfInterestModel!.articlesOfInterest![index],
                            );
                          },
                        ))
            ],
          ),
        );
      },
    );
  }
}
