import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_cubit.dart';
import 'package:jelanco_tracking_system/modules/today_submissions_modules/cubit/today_submissions_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

// تسليمات اليوم / سجلات اليوم
class TodaySubmissionsScreen extends StatelessWidget {
  const TodaySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TodaySubmissionsCubit todaySubmissionsCubit;
    return Scaffold(
      appBar: const MyAppBar(
        title: 'سجلات اليوم',
      ),
      body: Column(
        children: [
          const MyScreenTitleWidget(title: 'ما قمت بتسليمه اليوم'),
          BlocProvider(
            create: (context) => TodaySubmissionsCubit()..getTodaySubmissions(),
            child: BlocConsumer<TodaySubmissionsCubit, TodaySubmissionsStates>(
              listener: (context, state) {},
              builder: (context, state) {
                todaySubmissionsCubit = TodaySubmissionsCubit.get(context);
                return Expanded(
                  child: todaySubmissionsCubit.getTodaySubmissionsModel == null
                      ? const Center(child: MyLoader())
                      : todaySubmissionsCubit.getTodaySubmissionsModel!.submissions!.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: AssetImage(AssetsKeys.defaultNoSubmissionsImage2),
                                    height: 250,
                                  ),
                                  Text(
                                    'لا توجد تسليمات',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) {
                                if (index == todaySubmissionsCubit.todaySubmissionsList.length &&
                                    !todaySubmissionsCubit.isTodaySubmissionsLastPage) {
                                  if (!todaySubmissionsCubit.isTodaySubmissionsLoading) {
                                    todaySubmissionsCubit.getTodaySubmissions(
                                      page: todaySubmissionsCubit
                                              .getTodaySubmissionsModel!.pagination!.currentPage! +
                                          1,
                                    );
                                  }
                                  return Padding(
                                    padding: EdgeInsets.all(8.0.w),
                                    child: const Center(child: MyLoader()),
                                  );
                                }
                                final submission = todaySubmissionsCubit.todaySubmissionsList[index];

                                return UserSubmissionWidget(
                                  submission: submission,
                                  todaySubmissionsCubit: todaySubmissionsCubit,

                                  /// send the cubbiiit
                                  /// or find something for : edit task + comments count
                                  ///
                                );
                              },
                              itemCount: todaySubmissionsCubit.todaySubmissionsList.length +
                                  (todaySubmissionsCubit.isTodaySubmissionsLastPage ? 0 : 1),
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
