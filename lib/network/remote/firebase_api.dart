import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
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
    importance: Importance.max, // shows everywhere, allowed to makes noise, peek, and use full screen intents.
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    print('handleMessage method');
    if (message == null) return;

    // ex: navigate with arguments

    if (kDebugMode) {
      print('Handling a message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }
  }

  Future<void> initLocalNotification() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/jelanco_logo');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotification.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
          final message = RemoteMessage.fromMap(jsonDecode(payload as String));
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

      print('Message also contained a notification: ${message.notification}');
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
    print('firebaseToken $firebaseToken,\n firebaseTokenVar ${UserDataConstants.firebaseTokenVar}');
    if (firebaseToken != null && UserDataConstants.userId != null) {
      if (UserDataConstants.firebaseTokenVar != null && UserDataConstants.firebaseTokenVar != firebaseToken) {
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