import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_states.dart';

class NotificationsBadgeWidget extends StatelessWidget {
  const NotificationsBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBadgeCubit, NotificationsBadgeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotificationsBadgeCubit notificationsBadgeCubit = NotificationsBadgeCubit.get(context);
        return Container(
          margin: const EdgeInsetsDirectional.only(end: 18),
          child: InkWell(
            onTap: () {
              NavigationServices.navigateTo(
                context,
                NotificationsScreen(),
              );
            },
            child: notificationsBadgeCubit.unreadNotificationsCountModel == null ||
                    notificationsBadgeCubit.unreadNotificationsCountModel?.unreadNotificationsCount == 0
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
    );
  }
}
