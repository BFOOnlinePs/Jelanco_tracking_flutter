import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';

class OptionsWidget extends StatelessWidget {
  final List<MenuItemModel> menuItems;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const OptionsWidget({super.key, required this.menuItems, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: padding ?? const EdgeInsets.all(8),



      icon: child == null ? const Icon(Icons.more_vert) : null,
      child: child,
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
                Icon(
                  menuItems[index].icon,
                  color: menuItems[index].iconColor,
                ),
                const SizedBox(width: 8),
                Text(menuItems[index].label),
              ],
            ),
          ),
        );
      },
    );
  }
}
