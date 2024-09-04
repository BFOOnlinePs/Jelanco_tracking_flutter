import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/my_bloc_observer.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/core/values/constants.dart';
import 'package:jelanco_tracking_system/modules/assigned_tasks_modules/assigned_tasks_cubit/assigned_tasks_cubit.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_cubit/bottom_nav_bar_cubit.dart';
import 'package:jelanco_tracking_system/modules/bottom_nav_bar_modules/bottom_nav_bar_screens.dart';
import 'package:jelanco_tracking_system/modules/splash_modules/splash_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_cubit.dart';
import 'core/constants/user_data.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  SocketIO(); // This will initialize the singleton instance

  UserDataConstants.token = CacheHelper.getData(key: MyCacheKeys.token);
  UserDataConstants.userId = CacheHelper.getData(key: MyCacheKeys.userId);
  UserDataConstants.name = CacheHelper.getData(key: MyCacheKeys.name);
  UserDataConstants.email = CacheHelper.getData(key: MyCacheKeys.email);
  UserDataConstants.jobTitle = CacheHelper.getData(key: MyCacheKeys.jobTitle);
  print('CacheHelper.getData(key: MyCacheKeys.permissionsList): ${CacheHelper.getData(key: MyCacheKeys.permissionsList)}');
  UserDataConstants.permissionsList = CacheHelper.getData(key: MyCacheKeys.permissionsList);

  print('token: ${UserDataConstants.token.toString()}');
  print('userId: ${UserDataConstants.userId.toString()}');
  print('name: ${UserDataConstants.name.toString()}');
  print('email: ${UserDataConstants.email.toString()}');
  print('jobTitle: ${UserDataConstants.jobTitle.toString()}');
  print('permissionsList: ${UserDataConstants.permissionsList.toString()}');

  Widget homeWidget;

  if (UserDataConstants.token == null || UserDataConstants.token == '') {
    homeWidget = const LoginScreen();
  } else {
    // homeWidget = HomeScreen();
    homeWidget = BottomNavBarScreens();
  }

  runApp(
    RestartWidget(
      child: EasyLocalization(
        supportedLocales: Constants.locals,
        path: AssetsKeys.translations,
        fallbackLocale: Constants.defaultLocal,
        startLocale: Constants.defaultLocal,
        child: MyApp(
          homeWidget: homeWidget,
        ),
      ),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  Widget homeWidget;

  MyApp({super.key, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    print('homeWidget in MyApp: $homeWidget');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavBarCubit()),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getUserSubmissions()
            ..getTasksToSubmit(
              perPage: 3,
              loadingState: GetTasksToSubmitLoadingState(),
              successState: GetTasksToSubmitSuccessState(),
              errorState: (error) => GetTasksToSubmitErrorState(error),
            ),
        ),
        BlocProvider(
            create: (context) =>
                TasksAddedByUserCubit()..getTasksAddedByUser()),
        BlocProvider(
            create: (context) => AssignedTasksCubit()..getAssignedTasks()),
      ],
      child: MaterialApp(
        title: 'جيلانكو - نظام التتبع',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorsConstants.primaryColor),
          fontFamily: 'Tajawal',
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: SplashScreen(
          homeWidget: homeWidget,
        ),
      ),
    );
  }
}
