/* // TODO: if not use delete

import 'dart:convert';

import 'package:albus_la_mobile/configs/routes/config_routes.dart';
import 'package:albus_la_mobile/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  FirebaseMessaging _firebaeMessaging = FirebaseMessaging.instance;
  FirebaseApi();

  final _androidChannel = const AndroidNotificationChannel(
    // 'high_importance_channel',
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for impoortant notification',
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
    // todo:
    print('=> _messagingBackgroundHandler');
    // print('Title: ${message.notification!.title}');
    // print('Body: ${message.notification!.body}');
    // print('Payload: ${message.data}');
  }

  void handleMessage(RemoteMessage? message) {
    print('==========> handleMessage');
    //  TODO: clean
/*     print('==========> handleMessage');
    print('message');
    print(message?.category);
    print(message?.collapseKey);
    print(message?.contentAvailable);
    print(message?.data);
    print(message?.from);
    print(message?.messageId);
    print(message?.messageType);
    print(message?.mutableContent);
    print(message?.notification);
    print(message?.senderId);
    print(message?.sentTime);
    print(message?.threadId);
    print(message?.ttl);
    print('===> notification android');
    print(message?.notification?.android?.channelId);
    print(message?.notification?.android?.clickAction);
    // print(message?.notification?.apple);
    print('message == null');
    print(message == null); */
    if (message == null) return;
    // TODO: before
    /* navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    ); */

    print('==========> start navigatorKey');
    navigatorKey.currentState?.pushNamed(
      Routes.manageAccountPage,
      arguments: {},
    );
    print('==========> end navigatorKey');
  }

  Future<void> initLocalNotifications() async {
    print('=> initLocalNotifications()');
    // final ios = IOSInit
    // const ios = IOSInit
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    //! IOS
    const ios = DarwinInitializationSettings();
    //! Android
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    // TODO; there is a Null checker problem
    await _localNotification.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: (details) {
        // TODO:
        print('=> onDidReceiveBackgroundNotificationResponse');
        print('details');
        print(details);
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
      onDidReceiveNotificationResponse: (details) {
        // TODO:
        print('=> onDidReceiveNotificationResponse');
        print('details');
        print(details);
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
    );

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    print('=> initPushNotifications');

    // await FirebaseMessaging.instance
    await _firebaeMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    _firebaeMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // TODO; there is a Null checker problem
    FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);
    // TODO; local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
    print('=> end of initPushNotifications');
  }

  Future<void> initNotifications() async {
    print('=> initNotifications');
    await _firebaeMessaging.requestPermission();
    // TODO:
    // final fcmToken = await _firebaeMessaging.getToken();
    // print('Token: $fcmToken');
    final fcmToken = await getFcm();
    print('Token: $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);
    initPushNotifications();
    initLocalNotifications();
  }

  Future<String> getFcm() async {
    print('=> getFcm()');
    return await _firebaeMessaging.getToken() ?? '';
  }
}
 */
