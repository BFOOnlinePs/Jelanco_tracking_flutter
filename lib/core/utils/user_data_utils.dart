import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_login_model.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';
import 'package:jelanco_tracking_system/network/remote/firebase_api.dart';

class UserDataUtils {
  // only save token and userId to the local storage
  static Future<void> saveUserDataToLocalStorage({
    required UserLoginModel userLoginModel,
  }) async {

    await CacheHelper.saveData(
      key: MyCacheKeys.token,
      value: userLoginModel.token,
    ).then((value) async {
      await CacheHelper.saveData(
        key: MyCacheKeys.userId,
        value: userLoginModel.user?.id,
      );
      UserDataConstants.token = userLoginModel.token;
      UserDataConstants.userId = userLoginModel.user!.id;

      // to give it an FCM token and save it in the database
      // await FirebaseApi().initNotification();
      // UserDataConstants.firebaseTokenVar = CacheHelper.getData(key: 'firebaseToken');
    });
  }
}
