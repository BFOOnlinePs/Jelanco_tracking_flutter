import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/main.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';
import 'package:jelanco_tracking_system/network/remote/fcm_services.dart';

// Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

class FirebaseApi {
  final messaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // same in manifest
    'High Importance Notification',
    description: 'this channel is used for important notifications',
    // importance: Importance.defaultImportance,
    importance: Importance.max,
    // shows everywhere, allowed to makes noise, peek, and use full screen intents.
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  // navigate to screen when notification is clicked
  void handleMessage(RemoteMessage? message) {
    print('handleMessage method');
    if (message == null) return;

    if (kDebugMode) {
      print('Handling a message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    print('message.data: ${message.data}');

    // Extract the 'type' and 'type_id', they could be null
    String? type = message.data['type'];
    String? typeId = message.data['type_id'];

    // Navigate based on the type and pass the taskId if available
    if (type == 'task' && typeId != null) {
      // type id is taskId
      print('navigate to task details screen');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => TaskDetailsScreen(taskId: int.parse(typeId)),
        ),
      );
    } else if (type == 'submission' && typeId != null) {
      // type id is submissionId
      print('navigate to submission details screen');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) =>
              TaskSubmissionDetailsScreen(submissionId: int.parse(typeId)),
        ),
      );
    } else if (type == 'comment' && typeId != null) {
      // type id is submissionId (where the comment belongs to)
      print('navigate to submission details screen');
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) =>
              TaskSubmissionDetailsScreen(submissionId: int.parse(typeId)),
        ),
      );
    } else if (type == 'general_screen') {
      print('navigate to general screen');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => GeneralScreen()),
      // );
    }
    // Handle other cases or handle null types if needed
  }

  Future<void> initLocalNotification() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/jelanco_logo');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotification.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload as String));
      print('call handleMessage method');
      handleMessage(message);
    });

    // it different for IOS
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform!.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotification() async {
    // IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Display the notification message as an alert
      badge: true, // Display the badge on the app icon
      sound: true, // Play a sound when the notification is shown
    );

    //  app is terminated and i opened it
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleMessage); // handleMessage when opens from notification...

    // app in background and i opened it
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      final notification = message.notification;
      if (notification == null) return;

      print(
          'Message also contained a notification title: ${message.notification?.title}');
      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/jelanco_logo',
              importance: Importance.max,
              playSound: true,
              sound: const RawResourceAndroidNotificationSound(
                  'notification_sound'),
              // actions:
            ),
          ),
          // pass the data notification to local notification
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotification() async {
    // iOS app users need to grant permission to receive messages
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    // getToken(): It requests a registration token for sending messages to users from your App server or other trusted server environment.
    String? firebaseToken = await messaging.getToken();
    //     .then((value) {
    //   print('value in getToken() $value');
    //   firebaseToken = firebaseToken;
    //   FCMServices.saveFCMTokenLocallyAndInServer(value!);
    // });

    // firebaseTokenVar from local storage
    // firebaseToken from firebase
    print(
        'firebaseToken $firebaseToken,\n firebaseTokenVar ${UserDataConstants.firebaseTokenVar}');
    if (firebaseToken != null && UserDataConstants.userId != null) {
      if (UserDataConstants.firebaseTokenVar != null &&
          UserDataConstants.firebaseTokenVar != firebaseToken) {
        // update
        await FCMServices.updateFCMTokenInLocalAndServer(
            UserDataConstants.firebaseTokenVar!, firebaseToken);
        print('token updated');
      } else {
        if (UserDataConstants.firebaseTokenVar == null) {
          // add
          await FCMServices.saveFCMTokenLocallyAndInServer(firebaseToken);
          print('token saved');
        }
      }
    } else {
      print(
          "this firebaseToken is already saved or the user did not logged in or Firebase token is null");
    }

    // i handled the refresh in different way
    // it is called when the token refreshed
    messaging.onTokenRefresh.listen((String? token) {
      print("FCM Token Refreshed: $token");
      // Send the refreshed token to your server for storage.
    });

    if (kDebugMode) {
      print('Registration Token= $firebaseToken');
    }

    initPushNotification();
    initLocalNotification();
  }
}
