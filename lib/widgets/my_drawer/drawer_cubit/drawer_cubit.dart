import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_logout_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_cubit.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:jelanco_tracking_system/network/remote/fcm_services.dart';
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

      // remove number of unread notifications
      NotificationsBadgeCubit.get(context).unreadNotificationsCountModel = null;

      CacheHelper.removeData(key: MyCacheKeys.token).then((_) {
        CacheHelper.removeData(key: MyCacheKeys.userId);
      }).then((_) async {
        // i have to delete my fcm token from local and server before clear user data constants
        await FCMServices.deleteFCMTokenFromLocalAndServer(UserDataConstants.firebaseTokenVar ?? '');

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
