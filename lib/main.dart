import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/my_bloc_observer.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_screen.dart';
import 'package:jelanco_tracking_system/modules/splash_modules/splash_screen.dart';

import 'core/constants/user_data.dart';
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
  // firebaseTokenVar = CacheHelper.getData(key: 'firebaseToken');

  print('token: ${UserDataConstants.token.toString()}');
  print('userId: ${UserDataConstants.userId.toString()}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelanco Tracking System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:  LoginScreen(),
      home: SplashScreen(
        homeWidget: LoginScreen(),
      ),
    );
  }
}
