import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/cubit/articles_of_interest_cubit.dart';
import 'package:jelanco_tracking_system/modules/articles_of_interest_modules/widgets/articles_of_interest_tab_body.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_tab_bar.dart';

class ArticlesOfInterestScreen extends StatelessWidget {
  final int interestedPartyId;

  const ArticlesOfInterestScreen({super.key, required this.interestedPartyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticlesOfInterestCubit()..init(interestedPartyId: interestedPartyId),
      child: Scaffold(
        appBar: MyAppBar(
          title: 'الإشارات والوسوم',
        ),
        body: MyTabBar(
          length: 2,
          tabs: const [Tab(text: 'المهام'), Tab(text: 'التكليفات')],
          expandedChild: TabBarView(
            children: [
              ArticlesOfInterestTabBody(isTask: true, interestedPartyId: interestedPartyId),
              ArticlesOfInterestTabBody(isTask: false, interestedPartyId: interestedPartyId),
            ],
          ),
        ),
      ),
    );
  }
}
