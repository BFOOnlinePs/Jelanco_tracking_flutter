import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/notifications_widgets/filter_chip_widget.dart';

class NotificationFilter extends StatefulWidget {
  const NotificationFilter({super.key});

  @override
  _NotificationFilterState createState() => _NotificationFilterState();
}

class _NotificationFilterState extends State<NotificationFilter> {
  int selectedFilter = 0; // 0: All, 1: Read, 2: Unread

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilterChipWidget(
            label: 'الكل',
            icon: Icons.notifications_active_outlined,
            isSelected: selectedFilter == 0,
            onTap: () {
              setState(() {
                selectedFilter = 0;
              });
            },
          ),
          FilterChipWidget(
            label: 'المقروء',
            icon: Icons.done_all,
            isSelected: selectedFilter == 1,
            onTap: () {
              setState(() {
                selectedFilter = 1;
              });
            },
          ),
          FilterChipWidget(
            label: 'غير المقروء',
            icon: Icons.mark_email_unread_outlined,
            isSelected: selectedFilter == 2,
            onTap: () {
              setState(() {
                selectedFilter = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}
