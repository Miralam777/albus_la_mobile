import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../routes/routes.dart';
import '../../theme/app_themes.dart';
import '../../../constants/consts.dart';

// TODO: clean
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

class MessagingService {
  static String? fcmToken;

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ///* in home: final _messagingService = MessagingService();
  ///* then use this method in home initState()
  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications

    try {
      await _fcm.requestPermission();
    } catch (_) {}

    // TODO:
    // await _fcm.subscribeToTopic("all"); */
    await _fcm.subscribeToTopic("dev2");

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((message) async {
      //* show only on android
      if (Platform.isAndroid) _showLocalNotification(context, message);
    });

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleNotificationClick(context, message);
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(context, message);
    });
  }

  void _showLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    localNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(
          '@drawable/ic_stat_launch_icon_transparent',
        ),
      ),
      //* on local notification click
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) =>
              _handleNotificationClick(context, message),
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'default_notification_channel_id',
      'High Importance Notifications',
      description: 'This channel is used for impoortant notification',
      importance: Importance.high,
    );

    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    RemoteNotification? notification = message.notification;

    if (notification != null) {
      // TODO: new user avatar
      // ! ***************
      // Bild herunterladen und speichern
      // String? imageUrl = message.data['image'];
      /*       String? imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/topc_images%2Faccident_1.png?alt=media&token=0f3afe2c-9619-40d3-a617-94905e4a757b';
      File? imageFile;

      if (imageUrl != null) {
        var response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          var documentDirectory = await getApplicationDocumentsDirectory();
          var filePath = '${documentDirectory.path}/avatar.jpg';
          imageFile = File(filePath);
          imageFile.writeAsBytesSync(response.bodyBytes);
        }
      } */
      // ! ***************
      await localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_stat_launch_icon_transparent',
            color: WidgetThemes.lightPrimaryColor,
            // TODO: new
            //! topic image
            // styleInformation: imageFile != null? BigPictureStyleInformation(FilePathAndroidBitmap(imageFile.path)): null,
            //! user avatar
            // largeIcon: imageFile != null? FilePathAndroidBitmap(imageFile.path ?? ''): null,
          ),
        ),
      );
    }
  }

  //* Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    // TODO: clean
    print('=========> onMessageOpenedApp');
    print('=========> message');
    print(message.toMap());
    print('=========> android');
    print(message.notification?.android?.toMap());
    print('=========> apple');
    print(message.notification?.apple?.toMap());

    final type = message.data['type'] as String?;
    print('============> type: $type');

    /*     final id = message.data['id'].runtimeType == int
        ? message.data['id'] as int
        : int.tryParse(message.data['id'] ?? ''); */
    // final id = message.data['id'] as String?;

    // print('=========> id: $id');

    if (type == K.pushType) {
      print('=========> push');
      // TODO: push details page
      /* context.push(Routes.pushNfcDetailsPage, extra: {
        'imageUrl': Platform.isAndroid
            ? message.notification?.android?.imageUrl
            : message.notification?.apple?.imageUrl,
        'title': message.notification?.title,
        'body': message.notification?.body,
      }); */
    } else if (type == K.ordersPushType) {
      print('=========> extra');
      // final extra = jsonDecode(message.data['extra']) as Map<String, dynamic>?;
      // print(extra);

      print('====> message.data[messagesId]');
      print(message.data['messagesId']);

      if (message.data['messagesId'] != null) {
        // TODO:
        /*         context.push(
          Routes.messagesPage,
          extra: message.data['messagesId'],
        ); */
      }
    }

    /*       if (type == Str.pushTypeId) {
      print('=========> push');
      context.push(Routes.pushNfcDetailsPage, extra: {
        'imageUrl': Platform.isAndroid
            ? message.notification?.android?.imageUrl
            : message.notification?.apple?.imageUrl,
        'title': message.notification?.title,
        'body': message.notification?.body,
      });
    } else if (type == Str.newsTypeId && id != null) {
      print('=========> news');
      context.push(Routes.newsDetailsPage, extra: {'id': id});
    } else if (type == Str.clipTypeId && id != null) {
      print('=========> clip');
      context.push(Routes.clipDetailsPage, extra: {'id': id});
    } else if (type == Str.audioTypeId && id != null) {
      print('=========> audio');
      // TODO:
    }  */
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // debugPrint('Handling a background message: ${message.notification!.title}');
}
