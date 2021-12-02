import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:submission_restaurant_api/data/api/api_service.dart';

import '../main.dart';
import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService{
  static BackgroundService? _instance;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal(){
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {

    print('Alarm On!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    var randomNotif = await ApiService().randomRestaurant();

    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, randomNotif);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}