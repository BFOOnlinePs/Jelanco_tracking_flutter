import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType { storage, location, camera }

mixin PermissionsMixin<T> on Cubit<T> {
  PermissionStatus? permissionStatus;

  Future<void> requestPermission({
    required BuildContext context,
    required PermissionType permissionType,
    Future<void> Function()? functionWhenGranted,
  }) async {
    print('requestPermission for $permissionType');

    // Get device info to check Android SDK version
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final sdkVersion = deviceInfo.version.sdkInt;

    // Request permissions based on type and SDK version
    switch (permissionType) {
      case PermissionType.storage:
        if (sdkVersion > 32) {
          await _requestPhotosAndVideosPermissions();
          print('Storage permissions requested for Android SDK > 32');
        } else {
          permissionStatus = await Permission.storage.request();
          print('Storage permission requested for Android SDK <= 32');
        }
        break;

      case PermissionType.location:
        permissionStatus = await Permission.location.request();
        print('Location permission requested');
        break;

        case PermissionType.camera:
        permissionStatus = await Permission.camera.request();
        print('Camera permission requested');
        break;
    }

    print('Permission status: $permissionStatus');
    print('Is permanently denied: ${permissionStatus?.isPermanentlyDenied}');

    // Handle permission status
    if (permissionStatus?.isGranted == true) {
      print('${permissionType.toString()} permission granted');
      if (functionWhenGranted != null) {
        await functionWhenGranted();
      }
    } else if (permissionStatus?.isDenied == true) {
      print('${permissionType.toString()} permission denied');
      await _showPermissionDeniedDialog(context);
    }
    // You can handle other status cases such as `isPermanentlyDenied` or `isRestricted`
  }

  Future<void> _requestPhotosAndVideosPermissions() async {
    final photoPermission = await Permission.photos.request();
    final videoPermission = await Permission.videos.request();

    // Combine the status of photo and video permissions
    if (photoPermission.isGranted && videoPermission.isGranted) {
      permissionStatus = photoPermission; // Assuming both are granted
    } else {
      permissionStatus =
          PermissionStatus.denied; // Default to denied if any are denied
    }
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("permission_denied".tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("permission_needed").tr(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text('permission_go_to_settings').tr(),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("permission_exit_button").tr(),
          ),
        ],
      ),
    );
  }
}

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum PermissionType { storage, location }
// // enum PermissionType { photos, videos, location }
//
// mixin PermissionsMixin<T> on Cubit<T> {
//   PermissionStatus? permissionStatus;
//
//   Future<void> requestPermission({
//     required BuildContext context,
//     required PermissionType permissionType,
//     Future<void> Function()? functionWhenGranted,
//   }) async {
//     permissionStatus = null;
//     print('requestPermission');
//     print('permissionType: ${permissionType}');
//     switch (permissionType) {
//       // case PermissionType.photos:
//       // case PermissionType.videos:
//       case PermissionType.storage:
//         final deviceInfo = await DeviceInfoPlugin().androidInfo;
//         if (deviceInfo.version.sdkInt > 32) {
//
//           permissionStatus = await Permission.photos.request();
//           permissionStatus = await Permission.videos.request();
//           print('storage permission requested for > 32');
//         } else {
//           permissionStatus = await Permission.storage.request();
//           print('storage permission requested for < 32');
//         }
//         break;
//       case PermissionType.location:
//         permissionStatus = await Permission.location.request();
//         print('location permission requested');
//         break;
//     }
//
//     print('permissionStatus: ${permissionStatus}');
//     print('isPermanentlyDenied: ${permissionStatus?.isPermanentlyDenied}');
//
//     if (permissionStatus?.isGranted == true) {
//       // Permission granted, proceed to use the image picker
//       print('${permissionType.toString()} permission granted');
//       if (functionWhenGranted != null) {
//         await functionWhenGranted();
//       }
//     } else if (permissionStatus?.isDenied == true) {
//       print('${permissionType.toString()} permission denied');
//
//       // Permission denied, show an explanation and request again
//       showPermissionDeniedDialog(context);
//     }
//     // You can handle other status cases such as `isPermanentlyDenied` or `isRestricted`
//   }
//
//   Future<void> showPermissionDeniedDialog(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: Text("permission_denied".tr()),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("permission_needed").tr(),
//             TextButton(
//               onPressed: () {
//                 // openAppSettings();
//                 Navigator.of(context).pop();
//                 openAppSettings();
//               },
//               child: Text('permission_go_to_settings').tr(),
//             )
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("permission_exit_button").tr(),
//           ),
//         ],
//       ),
//     );
//   }
// }
