import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_add_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_tasks_to_submit_widget.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_submission_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/my_drawer.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..init(context, userId: UserDataConstants.userId!),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          homeCubit = HomeCubit.get(context);

          return Scaffold(
            appBar: MyAppBar(
              title: 'home_page_title'.tr(),
              actions: [
                UserDataConstants.userModel == null
                    ? Container()
                    : BlocConsumer<NotificationsBadgeCubit, NotificationsBadgeStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          NotificationsBadgeCubit notificationsBadgeCubit =
                              NotificationsBadgeCubit.get(context);
                          return Container(
                            margin: const EdgeInsetsDirectional.only(end: 18),
                            child: InkWell(
                              onTap: () {
                                NavigationServices.navigateTo(
                                  context,
                                  NotificationsScreen(),
                                );
                              },
                              child: notificationsBadgeCubit.unreadNotificationsCountModel == null
                                  ? const Icon(
                                      Icons.notifications,
                                      size: 25,
                                    )
                                  : Badge(
                                      label: Text(notificationsBadgeCubit
                                              .unreadNotificationsCountModel?.unreadNotificationsCount
                                              .toString() ??
                                          ''),
                                      largeSize: 18,
                                      textStyle: TextStyle(fontSize: 14),
                                      child: const Icon(
                                        Icons.notifications,
                                        size: 25,
                                      ),
                                    ),
                            ),
                          );
                        },
                      )
              ],
            ),
            drawer: UserDataConstants.userModel != null ? const MyDrawer() : null,
            body: MyRefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  NotificationsBadgeCubit.get(context).getUnreadNotificationsCount(),
                  homeCubit.getUserSubmissions(),
                  if (SystemPermissions.hasPermission(SystemPermissions.submitTask))
                    homeCubit.getTasksToSubmit(
                      perPage: 3,
                      loadingState: GetTasksToSubmitLoadingState(),
                      successState: GetTasksToSubmitSuccessState(),
                      errorState: (error) => GetTasksToSubmitErrorState(error),
                    ),
                ]);
              },
              child: UserDataConstants.userModel == null
                  ? const Center(child: MyLoader())
                  : CustomScrollView(
                      controller: homeCubit.scrollController,
                      slivers: [
                        // check if the user has a permission to add a submission
                        if (SystemPermissions.hasPermission(SystemPermissions.submitTask))
                          SliverToBoxAdapter(
                            child: HomeAddSubmissionWidget(
                              homeCubit: homeCubit,
                            ),
                          ),
                        if (SystemPermissions.hasPermission(SystemPermissions.submitTask))
                          SliverToBoxAdapter(
                            child: HomeTasksToSubmitWidget(
                              homeCubit: homeCubit,
                            ),
                          ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == homeCubit.userSubmissionsList.length &&
                                  !homeCubit.isUserSubmissionsLastPage) {
                                if (!homeCubit.isUserSubmissionsLoading) {
                                  homeCubit.getUserSubmissions(
                                    page: homeCubit.getUserSubmissionsModel!.pagination!.currentPage! + 1,
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(8.0.w),
                                  child: const LinearProgressIndicator(),
                                );
                              }
                              final submission = homeCubit.userSubmissionsList[index];

                              return UserSubmissionWidget(homeCubit: homeCubit, submission: submission);
                            },
                            childCount: homeCubit.userSubmissionsList.length +
                                (homeCubit.isUserSubmissionsLastPage
                                    ? 0
                                    : 1), // Replace with your data length
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
