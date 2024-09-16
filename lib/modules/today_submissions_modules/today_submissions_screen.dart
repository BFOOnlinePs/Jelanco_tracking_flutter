import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_cubit.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

class TodaySubmissionsScreen extends StatelessWidget {
  const TodaySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TodaySubmissionsCubit todaySubmissionsCubit;
    return Scaffold(
      appBar: const MyAppBar(
        title: 'تسليمات اليوم',
      ),
      body: Column(
        children: [
          const MyScreenTitleWidget(title: 'ما تم تسليمه اليوم'),
          BlocProvider(
            create: (context) =>
                TodaySubmissionsCubit()..getTodaySubmissions(),
            child:
                BlocConsumer<TodaySubmissionsCubit, TodaySubmissionsStates>(
              listener: (context, state) {},
              builder: (context, state) {
                todaySubmissionsCubit = TodaySubmissionsCubit.get(context);
                return todaySubmissionsCubit.getTodaySubmissionsModel == null
                    ? const Center(child: MyLoader())
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) =>
                              UserSubmissionWidget(
                                  submission: todaySubmissionsCubit
                                      .getTodaySubmissionsModel!
                                      .submissions![index],

                              /// send the cubbiiit
                                /// or find something for : edit task + comments count
                                ///
                              ),
                          itemCount: todaySubmissionsCubit
                              .getTodaySubmissionsModel!.submissions!.length,
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
