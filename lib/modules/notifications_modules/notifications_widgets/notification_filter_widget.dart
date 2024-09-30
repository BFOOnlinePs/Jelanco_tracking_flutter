import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_cubit.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_widgets/filter_chip_widget.dart';

class NotificationFilterWidget extends StatelessWidget {
  const NotificationFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsCubit notificationsCubit = NotificationsCubit.get(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilterChipWidget(
            label: 'الكل',
            icon: Icons.notifications_active_outlined,
            isSelected: notificationsCubit.selectedFilter == 2,
            onTap: () {
              notificationsCubit.changeSelectedFilter(2);
            },
          ),
          FilterChipWidget(
            label: 'المقروء',
            icon: Icons.done_all,
            isSelected: notificationsCubit.selectedFilter == 1,
            onTap: () {
              notificationsCubit.changeSelectedFilter(1);
            },
          ),
          FilterChipWidget(
            label: 'غير المقروء',
            icon: Icons.mark_email_unread_outlined,
            isSelected: notificationsCubit.selectedFilter == 0,
            onTap: () {
              notificationsCubit.changeSelectedFilter(0);
            },
          ),
        ],
      ),
    );
  }
}
