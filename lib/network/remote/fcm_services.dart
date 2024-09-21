import 'package:dio/dio.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';

class FCMServices {
  static final Dio _dio = Dio();

  // when login,
  static Future<void> saveFCMTokenLocallyAndInServer(String token) async {
    try {
      print('token in saveFCMTokenLocallyAndInServer method: $token');

      // is same token as shared preference? if not the same, add it to the database and shared preference
      // if (token == CacheHelper.getData(key: 'firebaseToken')) return;

      // save in server:
      final response = await _dio.post(
        EndPointsConstants.baseUrl + EndPointsConstants.storeFcmUserTokenEndPoint,
        // '$baseUrl$storeFcmUserTokenEndPoint',
        data: {'frt_user_id': UserDataConstants.userId, 'frt_registration_token': token},
      );

      if (response.statusCode == 200) {
        print('FCM Token saved in server successfully');

        // save locally
        await CacheHelper.saveData(key: MyCacheKeys.firebaseToken, value: token);
        // firebaseTokenVar = token;
      } else {
        print('Failed to save FCM Token. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error saving FCM Token: $error');
    }
  }

  // when logout, when account deleted(call logout), uninstall app, clears app data
  static Future<void> deleteFCMTokenFromLocalAndServer(String fcmToken) async {
    try {
      // delete from server
      final response = await _dio.post(
       EndPointsConstants.baseUrl + EndPointsConstants.deleteFcmUserTokenEndPoint,
        // '$baseUrl$deleteFcmUserTokenEndPoint',
        data: {'frt_user_id': UserDataConstants.userId, 'frt_registration_token': fcmToken},
      );

      if (response.statusCode == 200) {
        print('FCM Token deleted successfully');

        // delete from local
        await CacheHelper.removeData(key: 'firebaseToken');
        UserDataConstants.firebaseTokenVar = CacheHelper.getData(key: MyCacheKeys.firebaseToken);
      } else {
        print(
            'Failed to delete FCM Token. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting FCM Token: $error');
    }
  }

  // token (update) refresh
  static Future<void> updateFCMTokenInLocalAndServer(String oldToken, String newToken) async {
    try {
      final response = await _dio.post(
        EndPointsConstants.baseUrl + EndPointsConstants.updateFcmUserTokenEndPoint,
        // '$baseUrl$updateFcmUserTokenEndPoint',
        data: {
          'frt_user_id': UserDataConstants.userId,
          'frt_old_registration_token': oldToken,
          'frt_new_registration_token': newToken
        },
      );
      if (response.statusCode == 200) {
        print('FCM Token updated successfully');
        await CacheHelper.saveData(key: 'firebaseToken', value: newToken);
      } else {
        print(
            'Failed to update FCM Token. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating FCM Token: $error');
    }
  }

}
// token expire?
