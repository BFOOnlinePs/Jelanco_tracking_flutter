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
      // CacheHelper.removeData(key: MyCacheKeys.token).then((value) async {
      //   CacheHelper.removeData(key: MyCacheKeys.userId);
      //   CacheHelper.removeData(key: MyCacheKeys.name);
      //   CacheHelper.removeData(key: MyCacheKeys.email);
      //   CacheHelper.removeData(key: MyCacheKeys.jobTitle);
      //
      //   UserDataConstants.userId =
      //       null; // empty it so the data of previous user did not show
      //   UserDataConstants.name =
      //       null; // empty it so the data of previous user did not show
      //   UserDataConstants.email =
      //       null; // empty it so the data of previous user did not show
      //   UserDataConstants.jobTitle =
      //       null; // empty it so the data of previous user did not show
      //   UserDataConstants.token =
      //       null; // empty it so the data of previous user did not show
      //
      //   HomeCubit.get(context).close();
      //
      //   if (TasksAddedByUserCubit.get(context).getTasksAddedByUserModel !=
      //       null) {
      //     TasksAddedByUserCubit.get(context).close();
      //   }
      //   if (AssignedTasksCubit.get(context).getTasksAssignedToUserModel !=
      //       null) {
      //     AssignedTasksCubit.get(context).close();
      //   }
      //
      //   BottomNavBarCubit.get(context).close();
      //
      //   // context.read<HomeCubit>().close();
      //   // context.read<TasksAddedByUserCubit>().close();
      //   // context.read<AssignedTasksCubit>().close();
      //   // context.read<BottomNavBarCubit>().close();
      //
      //   // HomeCubit.get(context).getUserSubmissionsModel = null;
      //   // HomeCubit.get(context).userSubmissionsList = [];
      //   // HomeCubit.get(context).isUserSubmissionsLastPage = false;
      //   //
      //   // HomeCubit.get(context).getSubmissionCommentCountModel = null;
      //   // HomeCubit.get(context).tasksAssignedToUserList = [];
      //   // HomeCubit.get(context).isTasksAssignedToUserLastPage = false;
      //   //
      //   // HomeCubit.get(context).getTasksToSubmitModel = null;
      //   //
      //   // TasksAddedByUserCubit.get(context).getTasksAddedByUserModel = null;
      //   // TasksAddedByUserCubit.get(context).tasksAddedByUserList = [];
      //   // TasksAddedByUserCubit.get(context).isTasksAddedByUserLastPage = false;
      //   //
      //   // AssignedTasksCubit.get(context).getTasksAssignedToUserModel = null;
      //   // AssignedTasksCubit.get(context).tasksAssignedToUserList = [];
      //   // AssignedTasksCubit.get(context).isTasksAssignedToUserLoading = false;
      //
      //   // await FCMServices.deleteFCMTokenFromLocalAndServer(firebaseTokenVar!);
      //
      //   // runApp(
      //   //   EasyLocalization(
      //   //     supportedLocales: Constants.locals,
      //   //     path: AssetsKeys.translations,
      //   //     fallbackLocale: Constants.defaultLocal,
      //   //     startLocale: Constants.defaultLocal,
      //   //     child: MyApp(
      //   //       homeWidget: LoginScreen(),
      //   //     ),
      //   //   ),
      //   // );
      //   // Simulate logout and clear the authenticated state
      //   // context.read<AuthNotifier>().logout();
      //   emit(LogoutSuccessState(userLogoutModel: userLogoutModel!));
      // });
      // Remove cached user data
      CacheHelper.removeData(key: MyCacheKeys.token).then((_) {
        CacheHelper.removeData(key: MyCacheKeys.userId);
        CacheHelper.removeData(key: MyCacheKeys.name);
        CacheHelper.removeData(key: MyCacheKeys.email);
        CacheHelper.removeData(key: MyCacheKeys.jobTitle);
        CacheHelper.removeData(key: MyCacheKeys.permissionsList);
      }).then((_) {
        // Clear static user data constants
        UserDataConstants.userId = null;
        UserDataConstants.name = null;
        UserDataConstants.email = null;
        UserDataConstants.jobTitle = null;
        UserDataConstants.token = null;
        UserDataConstants.permissionsList = [];

        // Restart the app to clear old state
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => LoginScreen()),
        //       (Route<dynamic> route) => false,
        // );
        RestartWidget.restartApp(context);
        // emit(LogoutSuccessState(userLogoutModel: userLogoutModel!));
      });
    }).catchError((error) {
      emit(LogoutErrorState(error: error.toString()));
      print(error);
    });
  }
}
