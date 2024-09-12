import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/main.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_logout_model.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_cubit.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_cubit.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/drawer_cubit/drawer_states.dart';

class DrawerCubit extends Cubit<DrawerStates> {
  DrawerCubit() : super(DrawerInitialState());

  static DrawerCubit get(context) => BlocProvider.of(context);

  UserLogoutModel? userLogoutModel;

  void userLogout(BuildContext context) {
    emit(LogoutLoadingState());
    DioHelper.postData(
      url: EndPointsConstants.logout,
    ).then((value) {
      print(value);
      userLogoutModel = UserLogoutModel.fromMap(value?.data);

      CacheHelper.removeData(key: MyCacheKeys.token).then((_) {
        CacheHelper.removeData(key: MyCacheKeys.userId);
        // CacheHelper.removeData(key: MyCacheKeys.name);
        // CacheHelper.removeData(key: MyCacheKeys.email);
        // CacheHelper.removeData(key: MyCacheKeys.jobTitle);
        // CacheHelper.removeData(key: MyCacheKeys.permissionsList);
      }).then((_) {
        // Clear static user data constants
        UserDataConstants.userId = null;
        UserDataConstants.name = null;
        UserDataConstants.email = null;
        UserDataConstants.image = null;
        UserDataConstants.jobTitle = null;
        UserDataConstants.token = null;
        UserDataConstants.userModel = null;
        UserDataConstants.permissionsList = [];

        // Restart the app to clear old state
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        //       (Route<dynamic> route) => false,
        // );


        // RestartWidget.restartApp(context);

        emit(LogoutSuccessState(userLogoutModel: userLogoutModel!));
      });
    }).catchError((error) {
      emit(LogoutErrorState(error: error.toString()));
      print(error);
    });
  }
}
