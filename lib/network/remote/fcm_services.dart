import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class FCMServices {
  // when login,
  static Future<void> saveFCMTokenLocallyAndInServer(String token) async {
    print('token in saveFCMTokenLocallyAndInServer method: $token');

    // is same token as shared preference? if not the same, add it to the database and shared preference
    // if (token == CacheHelper.getData(key: MyCacheKeys.firebaseToken)) return;

    // save in server:
    await DioHelper.postData(
      url: EndPointsConstants.baseUrl +
          EndPointsConstants.storeFcmUserTokenEndPoint,
      data: {
        'frt_user_id': UserDataConstants.userId,
        'frt_registration_token': token
      },
    ).then((value) async {
      print('FCM Token saved in server successfully');

      // save locally
      await CacheHelper.saveData(key: MyCacheKeys.firebaseToken, value: token);
      UserDataConstants.firebaseTokenVar =
          CacheHelper.getData(key: MyCacheKeys.firebaseToken);
    }).catchError((error) {
      print(error.toString());
    });
  }

  // when logout, when account deleted(call logout), uninstall app, clears app data
  static Future<void> deleteFCMTokenFromLocalAndServer(String fcmToken) async {
    print('logout');
    print('FCM Token: $fcmToken');
    print('User ID: ${UserDataConstants.userId}');
    print(
        'Request URL: ${EndPointsConstants.baseUrl + EndPointsConstants.deleteFcmUserTokenEndPoint}');

    final response = await DioHelper.postData(
      url: EndPointsConstants.baseUrl +
          EndPointsConstants.deleteFcmUserTokenEndPoint,
      // '$baseUrl$deleteFcmUserTokenEndPoint',
      data: {
        'frt_user_id': UserDataConstants.userId,
        'frt_registration_token': fcmToken,
      },
    ).then((value) async {
      print(value?.data);

      print('FCM Token deleted successfully');

      // delete from local
      await CacheHelper.removeData(key: MyCacheKeys.firebaseToken);
      UserDataConstants.firebaseTokenVar =
          CacheHelper.getData(key: MyCacheKeys.firebaseToken);
      print(
          'firebsae token in constants: ${UserDataConstants.firebaseTokenVar}');
      print(
          'firebsae token in local storage: ${CacheHelper.getData(key: MyCacheKeys.firebaseToken)}');
    }).catchError((error) {
      print(error.toString());
    });
  }

  // token (update) refresh
  static Future<void> updateFCMTokenInLocalAndServer(
      String oldToken, String newToken) async {
    final response = await DioHelper.postData(
      url: EndPointsConstants.baseUrl +
          EndPointsConstants.updateFcmUserTokenEndPoint,
      // '$baseUrl$updateFcmUserTokenEndPoint',
      data: {
        'frt_user_id': UserDataConstants.userId,
        'frt_old_registration_token': oldToken,
        'frt_new_registration_token': newToken
      },
    ).then((value) async {
      print(value?.data);
      print('FCM Token updated successfully');
      await CacheHelper.saveData(
          key: MyCacheKeys.firebaseToken, value: newToken);
    }).catchError((error) {
      print(error.toString());
    });
  }
}
// token expire?
