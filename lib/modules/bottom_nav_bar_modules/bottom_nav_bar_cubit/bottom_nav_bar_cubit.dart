import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_screen.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_cubit/bottom_nav_bar_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_screen.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_screen.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarStates> {
  BottomNavBarCubit() : super(BottomNavBarInitialState());

  static BottomNavBarCubit get(context) => BlocProvider.of(context);

  int bottomNavBarIndex = 1;

  List<Widget> bottomNavBarScreensList = [
    const TasksAddedByUserScreen(
      showAppBar: false,
    ),
    HomeScreen(),
    AssignedTasksScreen(
      showAppBar: false,
    ),
  ];

  void changeBottomNavBarIndex(int index) {
    bottomNavBarIndex = index;
    emit(ChangeBottomNavBarIndexState());
  }
}
