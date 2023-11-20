import 'dart:convert';

import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _NotificationType { newOrder, outOfStock, unspecified }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  showBadge: true,
  enableVibration: true,
  playSound: true,
  enableLights: true,
);

const settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

class PushNotificationsService {
  static const String adminTopic = 'ADMIN';

  final ProviderReference _providerRef;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PushNotificationsService(this._providerRef);

  Future<void> setAdminNotificationsSubscriptionActive(bool isActive) {
    if (kIsWeb) {
      return Future.value();
    } else {
      if (isActive) {
        return FirebaseMessaging.instance.subscribeToTopic(adminTopic);
      } else {
        return FirebaseMessaging.instance.unsubscribeFromTopic(adminTopic);
      }
    }
  }

  Future<void> init() async {
    if (kIsWeb) {
      return Future.value();
    } else {
      try {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          print('User granted push permission');
        } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional) {
          print('User granted provisional permission');
        } else {
          print('User declined or has not accepted permission');
        }

        await FirebaseMessaging.instance.getInitialMessage().then((msg) {
          if (msg != null) {
            _processNotification(msg.data);
          }
        });

        if (defaultTargetPlatform == TargetPlatform.android) {
          final initSettings = InitializationSettings(android: settingsAndroid);

          await _flutterLocalNotificationsPlugin.initialize(
            initSettings,
            onDidReceiveNotificationResponse: (response) async {
              final payload = response.payload;
              if (payload != null) {
                _processNotification(
                    jsonDecode(payload) as Map<String, dynamic>);
              }
            },
          );

          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(channel);
        }

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        FirebaseMessaging.onMessage.listen(_onMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(
          (msg) => _processNotification(msg.data),
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _onMessage(RemoteMessage? payload) async {
    print('onMessage');
    print(payload);
    if (payload == null) {
      return;
    }

    final notification = payload.notification;

    if (notification != null && notification.android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: notification.android?.smallIcon,
          ),
        ),
        payload: jsonEncode(payload.data),
      );
    } else {
      _processNotification(payload.data);
    }
  }

  void _processNotification(Map<String, dynamic> payload) {
    print('Process notification');
    print(payload);

    switch (_parseNotificationTag(payload)) {
      case _NotificationType.newOrder:
        _providerRef
            .read(navigationProvider.notifier)
            .openOrder(payload['new_order_uid'] as String);
        break;
      case _NotificationType.outOfStock:
        _providerRef
            .read(navigationProvider.notifier)
            .openProduct(payload['product_uid'] as String);
        break;
      case _NotificationType.unspecified:
        break;
    }
  }

  _NotificationType _parseNotificationTag(
    Map<String, dynamic> notificationPayload,
  ) {
    switch (notificationPayload['action_tag']) {
      case 'new_order':
        return _NotificationType.newOrder;
      case 'out_of_stock':
        return _NotificationType.outOfStock;
      default:
        return _NotificationType.unspecified;
    }
  }
}
