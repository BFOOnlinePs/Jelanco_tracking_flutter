import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_cubit/bottom_nav_bar_states.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_widgets/nav_bar_icon_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/my_drawer.dart';

class BottomNavBarScreens extends StatelessWidget {
  BottomNavBarScreens({super.key});

  late BottomNavBarCubit bottomNavBarCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBarCubit, BottomNavBarStates>(
      listener: (context, state) {},
      builder: (context, state) {
        bottomNavBarCubit = BottomNavBarCubit.get(context);

        return Scaffold(
          appBar: MyAppBar(
            title: 'home_page_title'.tr(),
          ),
          drawer: MyDrawer(),
          body: bottomNavBarCubit
              .bottomNavBarScreensList[bottomNavBarCubit.bottomNavBarIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: NavBarIconWidget(icon: FontAwesomeIcons.list),
                label: 'المهام التي أضفتها',
              ),
              BottomNavigationBarItem(
                icon: NavBarIconWidget(icon: FontAwesomeIcons.house),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: NavBarIconWidget(icon: FontAwesomeIcons.listCheck),
                label: 'المهام الموكلة إلي',
              ),
            ],
            currentIndex: bottomNavBarCubit.bottomNavBarIndex,
            selectedItemColor: Colors.blue,
            // onTap: bottomNavBarCubit.changeBottomNavBarIndex(index),
            onTap: (index) {
              bottomNavBarCubit.changeBottomNavBarIndex(index);
            },
          ),
        );
      },
    );
  }
}
