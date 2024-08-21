import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';

class TaskOptionsWidget extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  TaskOptionsWidget({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        // Find the selected menu item (depend on the index) and call its onTap action
        final menuItem = menuItems[value];
        menuItem.onTap();
      },
      itemBuilder: (context) {
        return List<PopupMenuEntry<int>>.generate(
          menuItems.length,
              (index) => PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Icon(menuItems[index].icon),
                SizedBox(width: 8),
                Text(menuItems[index].label),
              ],
            ),
          ),
        );
      },
    );
  }
}
