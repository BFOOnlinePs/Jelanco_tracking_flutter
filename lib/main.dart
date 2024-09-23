import 'package:bloc/bloc.dart';

// import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/firebase_options.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_screen.dart';
import 'package:jelanco_tracking_system/network/remote/firebase_api.dart';
import 'package:jelanco_tracking_system/network/remote/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/my_bloc_observer.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/core/values/constants.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/splash_modules/splash_screen.dart';
import 'core/constants/user_data.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     name: 'jelanco-tracking',
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  SocketIO(); // This will initialize the singleton instance

  await Firebase.initializeApp(
    name: 'jelanco-tracking',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // debugPaintSizeEnabled = true;

  UserDataConstants.token = CacheHelper.getData(key: MyCacheKeys.token);
  UserDataConstants.userId = CacheHelper.getData(key: MyCacheKeys.userId);
  UserDataConstants.firebaseTokenVar =
      CacheHelper.getData(key: MyCacheKeys.firebaseToken);

  print('token: ${UserDataConstants.token.toString()}');
  print('userId: ${UserDataConstants.userId.toString()}');
  print('firebaseToken: ${UserDataConstants.firebaseTokenVar.toString()}');

  Widget homeWidget;

  if (UserDataConstants.token == null || UserDataConstants.token == '') {
    homeWidget = const LoginScreen();
  } else {
    // if the user logged in (to ensure that it did not initialize twice)
    await FirebaseApi().initNotification();

    homeWidget = HomeScreen();
    // homeWidget = BottomNavBarScreens();
  }


  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((_){
  runApp(
    // RestartWidget(
    //   child:
    EasyLocalization(
      supportedLocales: Constants.locals,
      path: AssetsKeys.translations,
      fallbackLocale: Constants.defaultLocal,
      startLocale: Constants.defaultLocal,
      // to disable device preview, remove DevicePreview child
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(
      //     homeWidget: homeWidget,
      //   ),
      // ),
      child: MyApp(
        homeWidget: homeWidget,
      ),
    ),
    // ),
  );
  // });
}

// Define a global key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  Widget homeWidget;

  MyApp({super.key, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 750),
      // Xiaomi Redmi 13C ( 750 without status bar and bottom nav bar)
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        // to disable device preview, comment these 3 lines and uncomment the 'locale :context.locale' line
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,

        navigatorKey: navigatorKey,
        // Assign the navigatorKey
        title: 'جيلانكو - نظام التتبع',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: ColorsConstants.primaryColor),
          fontFamily: 'Tajawal',
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
