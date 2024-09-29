import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/notifications_utils.dart';
import 'package:jelanco_tracking_system/network/remote/fcm_services.dart';

// Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('in _firebaseMessagingBackgroundHandler');
  // Handle background/terminated notification message
  // Parse the data and navigate to the correct screen
  if (message.data['type'] == 'task') {
    // Navigate to the task details page
    print('Navigating to task details');
  }

  // await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

class FirebaseApi {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
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

  // Handles navigation based on message data.
  void _navigateBasedOnMessage(RemoteMessage? message) {
    print('handleMessage method');
    if (message == null) return;

    // if (kDebugMode) {
    print('Handling a message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
    // }

    print('message.data: ${message.data}');

    // Extract the 'type' and 'type_id', they could be null
    String? type = message.data['type'];
    String? typeId = message.data['type_id'];

    NotificationsUtils.navigateFromNotification(type: type, typeId: typeId);
  }

  // Initializes local notifications.
  Future<void> _initLocalNotification() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/jelanco_logo'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final message =
            RemoteMessage.fromMap(jsonDecode(response.payload as String));
        print('call handleMessage method');
        print('Notification tapped, navigating...');
        _navigateBasedOnMessage(
            message); // Only navigate when the notification is tapped
      },
      // // new
      // onDidReceiveBackgroundNotificationResponse: onTapNotificationBackground,
    );

    // it different for IOS
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform!.createNotificationChannel(_androidChannel);
  }

  // Handles foreground and background push notifications.
  Future<void> _initPushNotification() async {
    // Set up iOS presentation options
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Display the notification message as an alert
      badge: true, // Display the badge on the app icon
      sound: true, // Play a sound when the notification is shown
    );

    //  app is terminated and i opened it
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('app os terminated and i opened it');
        _navigateBasedOnMessage(
            message); // Navigate based on the message when app is opened from terminated state
      }
    });

    // app in background and i opened it
    FirebaseMessaging.onMessageOpenedApp.listen(_navigateBasedOnMessage);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      final notification = message.notification;
      if (notification == null) return;

      print(
          'Message (in foreground) also contained a notification title: ${message.notification?.title}');
      // Show the notification, but do NOT navigate yet.
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
            sound:
                const RawResourceAndroidNotificationSound('notification_sound'),
            // actions:
          ),
        ),
        // pass the data notification to local notification
        payload: jsonEncode(message.toMap()),
      );

      // Comment out or remove the immediate navigation:
      // _navigateBasedOnMessage(message);
    });
  }

  // Requests notification permissions and initializes notifications.
  Future<void> initNotification() async {
    // await _initPushNotification();
    // await _initLocalNotification();

    // iOS app users need to grant permission to receive messages
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }

    // Get FCM token and save/update as needed
    String? firebaseToken = await messaging.getToken();

    _handleFCMToken(firebaseToken);

    // messaging.onTokenRefresh.listen(_handleFCMToken);

    // i handled the refresh in different way
    // it is called when the token refreshed
    messaging.onTokenRefresh.listen((String? token) {
      print("FCM Token Refreshed: $token");
      // Send the refreshed token to your server for storage.
    });

    if (kDebugMode) {
      print('Registration Token= $firebaseToken');
    }

    await _initPushNotification();
    await _initLocalNotification();
  }

  void _handleFCMToken(String? firebaseToken) async {
    // firebaseTokenVar from local storage
    // firebaseToken from firebase
    print('in _handleFCMToken');
    print(
        'firebaseToken $firebaseToken,\n firebaseTokenVar ${UserDataConstants.firebaseTokenVar}');
    // userId != null means the user must logged in
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

    //   if (firebaseToken == null || UserDataConstants.userId == null) {
    //     print(
    //         "this firebaseToken is already saved or the user did not logged in or Firebase token is null");
    //     return;
    //   }
    //
    //   if (UserDataConstants.firebaseTokenVar != firebaseToken) {
    //     await FCMServices.updateFCMTokenInLocalAndServer(
    //         UserDataConstants.firebaseTokenVar ?? '', firebaseToken);
    //     print('FCM token updated');
    //   } else {
    //     print('FCM token is already saved or user is not logged in');
    //   }
  }
}
