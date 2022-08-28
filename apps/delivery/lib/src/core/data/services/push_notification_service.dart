// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'dart:async';

import 'package:delivery/src/core/data/res/app_environment.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/orders/presentation/pages/order_detail_page.dart';
import 'package:delivery/src/features/orders/presentation/pages/orders_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

final _logger = Logger((PushNotificationService).toString());

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  PushNotificationService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _flutterLocalNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin();

  Future<void> init(Reader read) async {
    try {
      var settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _logger.fine('User granted push permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        _logger.fine('User granted provisional permission');
      } else {
        _logger.fine('User declined or has not accepted permission');
      }
      if (defaultTargetPlatform == TargetPlatform.android) {
        final initSettings = InitializationSettings(android: settingsAndroid);
        await _flutterLocalNotificationsPlugin!.initialize(initSettings,
            onSelectNotification: (orderId) async {
          _logger.fine('foreground clicked: $orderId');
          if (orderId!.isNotEmpty && orderId.split('__').length == 2) {
            read(navigationProvider).replaceRootStackWith(
              [
                AppPageNode(
                  page: HomePage(),
                  crossroad: NavigationCrossroad(
                    activeBranch: NestingBranch.orders,
                    availableBranches: {
                      NestingBranch.orders: NavigationStack(
                        [
                          AppPageNode(page: OrdersPage()),
                          AppPageNode(
                            page: OrderDetailPage(
                                orderUniqueId: orderId.split('__').last),
                          ),
                        ],
                      )
                    },
                  ),
                )
              ],
            );
          }
        });
        await _flutterLocalNotificationsPlugin!
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
      FirebaseMessaging.onMessage.listen(_onMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        var docId = message.data['document_id'] as String? ?? '';
        var orderId = message.data['order_id'] as String? ?? '';

        if (orderId.isNotEmpty && docId.isNotEmpty) {
          read(navigationProvider).replaceRootStackWith([
            AppPageNode(
              page: HomePage(),
              crossroad: NavigationCrossroad(
                  activeBranch: NestingBranch.orders,
                  availableBranches: {
                    NestingBranch.orders: NavigationStack(
                      [
                        AppPageNode(page: OrdersPage()),
                        AppPageNode(
                          page: OrderDetailPage(orderUniqueId: docId),
                        ),
                      ],
                    )
                  }),
            )
          ]);
        }
      });
    } catch (err, stack) {
      _logger.severe('failed push registration', err, stack);
    }
  }

  Future<String?> get currentToken async {
    String? token;
    try {
      token =
          await _firebaseMessaging.getToken(vapidKey: AppEnvironment.vapidKey);
      _logger.fine('token: $token');
      return token;
    } catch (e) {
      _logger.warning('failed getting FCM token ${e.toString()}');
      return token;
    }
  }

  void _onMessageHandler(RemoteMessage message) {
    _logger.fine('message in foreground: ${message.data}');
    var notification = message.notification;
    var android = notification?.android;
    if (notification != null && android != null) {
      var docId = message.data['document_id'] as String? ?? '';
      var orderId = message.data['order_id'] as String? ?? '';
      if (orderId.isNotEmpty && docId.isNotEmpty) {
        var payload = '${orderId}__$docId';
        _flutterLocalNotificationsPlugin!.show(
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
          payload: payload,
        );
      }
    }
  }

  Stream<String> get onTokenRefreshed => _firebaseMessaging.onTokenRefresh;

  static Future<void> handleMessageOpenedApp(Reader read) async {
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      var docId = initialMessage.data['document_id'] as String? ?? '';
      var orderId = initialMessage.data['order_id'] as String? ?? '';

      if (docId.isNotEmpty && orderId.isNotEmpty) {
        read(navigationProvider).replaceRootStackWith([
          AppPageNode(
            page: HomePage(),
            crossroad: NavigationCrossroad(
                activeBranch: NestingBranch.orders,
                availableBranches: {
                  NestingBranch.orders: NavigationStack(
                    [
                      AppPageNode(page: OrdersPage()),
                      AppPageNode(
                        page: OrderDetailPage(orderUniqueId: docId),
                      ),
                    ],
                  )
                }),
          )
        ]);
      }
    }
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  showBadge: true,
  enableVibration: true,
  playSound: true,
);

const settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
