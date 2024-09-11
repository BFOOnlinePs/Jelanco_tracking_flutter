import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_login_model.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';

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
      await CacheHelper.saveData(
        key: MyCacheKeys.name,
        value: userLoginModel.user?.name,
      );
      await CacheHelper.saveData(
        key: MyCacheKeys.email,
        value: userLoginModel.user?.email,
      );
      await CacheHelper.saveData(
        key: MyCacheKeys.jobTitle,
        value: userLoginModel.user?.jobTitle,
      );
      List<String> permissionsList =
          userLoginModel.permissions!.map<String>((permission) {
        return permission.name ?? '';
      }).toList();

      print('permissionsList: $permissionsList');
      await CacheHelper.saveData(
          key: MyCacheKeys.permissionsList, value: permissionsList);

      UserDataConstants.token = userLoginModel.token;
      UserDataConstants.userId = userLoginModel.user!.id;
      UserDataConstants.name = userLoginModel.user!.name;
      UserDataConstants.email = userLoginModel.user!.email;
      UserDataConstants.jobTitle = userLoginModel.user!.jobTitle;
      UserDataConstants.permissionsList = permissionsList;

      // to give it an FCM token and save it in the database
      // await FirebaseApi().initNotification();
      // firebaseTokenVar = CacheHelper.getData(key: 'firebaseToken');
    });
  }
}
