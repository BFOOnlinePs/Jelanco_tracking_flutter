import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/my_bloc_observer.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/core/values/constants.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/splash_modules/splash_screen.dart';
import 'package:video_compress/video_compress.dart';

import 'core/constants/user_data.dart';
import 'modules/home_modules/home_screen.dart';
import 'network/local/cache_helper.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  UserDataConstants.token = CacheHelper.getData(key: MyCacheKeys.token);
  UserDataConstants.userId = CacheHelper.getData(key: MyCacheKeys.userId);
  UserDataConstants.name = CacheHelper.getData(key: MyCacheKeys.name);
  UserDataConstants.email = CacheHelper.getData(key: MyCacheKeys.email);
  UserDataConstants.jobTitle = CacheHelper.getData(key: MyCacheKeys.jobTitle);

  print('token: ${UserDataConstants.token.toString()}');
  print('userId: ${UserDataConstants.userId.toString()}');
  print('name: ${UserDataConstants.name.toString()}');
  print('email: ${UserDataConstants.email.toString()}');
  print('jobTitle: ${UserDataConstants.jobTitle.toString()}');

  Widget homeWidget;

  if (UserDataConstants.token == null || UserDataConstants.token == '') {
    homeWidget = const LoginScreen();
  } else {
    homeWidget = HomeScreen();
  }

  runApp(
    EasyLocalization(
      supportedLocales: Constants.locals,
      path: AssetsKeys.translations,
      fallbackLocale: Constants.defaultLocal,
      startLocale: Constants.defaultLocal,
      child: MyApp(
        homeWidget: homeWidget,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget homeWidget;

  MyApp({super.key, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جيلانكو - نظام التتبع',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Tajawal',
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(
        homeWidget: homeWidget,
      ),
    );
  }
}
