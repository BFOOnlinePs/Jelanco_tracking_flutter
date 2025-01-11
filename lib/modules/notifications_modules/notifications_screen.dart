import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_cubit.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_states.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_widgets/notification_card.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_widgets/notification_filter_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..getUserNotifications(),
      child: BlocConsumer<NotificationsCubit, NotificationsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          NotificationsCubit notificationsCubit = NotificationsCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(
              title: 'الإشعارات',
            ),
            body: Stack( 
              children: [
                MyScreen(
                  child: Center(
                    child: Column(
                      children: [
                        const MyScreenTitleWidget(title: 'الإشعارات الخاصة بك'),
                        // The reason behind using ValueKey(notificationsCubit.selectedFilter) in NotificationFilter is
                        // to ensure that the widget can rebuild when the selectedFilter changes, so the UI will change.
                        NotificationFilterWidget(key: ValueKey(notificationsCubit.selectedFilter)),
                        notificationsCubit.getUserNotificationsModel == null
                            ? Container()
                            : notificationsCubit.getUserNotificationsModel!.notifications!.isEmpty
                                ? const Text('لا يوجد اشعارات حتى الان')
                                : Expanded(
                                    child: MyRefreshIndicator(
                                      onRefresh: () async {
                                        notificationsCubit.isRefresh = true;
                                        await notificationsCubit.getUserNotifications(
                                          newSelectedFilter: notificationsCubit.selectedFilter,
                                        );
                                        notificationsCubit.isRefresh = false;
                                      },
                                      child: ListView.builder(
                                        controller: notificationsCubit.scrollController,
                                        itemBuilder: (context, index) {
                                          if (index == notificationsCubit.userNotificationsList.length &&
                                              !notificationsCubit.isUserNotificationsLastPage) {
                                            if (!notificationsCubit.isUserNotificationsLoading) {
                                              notificationsCubit.isRefresh = true;
                                              notificationsCubit
                                                  .getUserNotifications(
                                                newSelectedFilter: notificationsCubit.selectedFilter,
                                                page: notificationsCubit
                                                        .getUserNotificationsModel!.pagination!.currentPage! +
                                                    1,
                                              )
                                                  .then((_) {
                                                notificationsCubit.isRefresh = false;
                                              });
                                            }
                                            return const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(child: MyLoader()),
                                            );
                                          }
                                          return NotificationCard(
                                            notificationModel: notificationsCubit.userNotificationsList[index],
                                          );
                                        },
                                        itemCount: notificationsCubit.userNotificationsList.length +
                                            (notificationsCubit.isUserNotificationsLastPage ? 0 : 1),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ),
                state is GetUserNotificationsLoadingState && !notificationsCubit.isRefresh
                    ? const LoaderWithDisable()
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
