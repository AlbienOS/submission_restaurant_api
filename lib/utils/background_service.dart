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
    var result = await ApiService().topHeadlines();
    var randomNotif = Random().nextInt(result.restaurants.length);
    var data = result.restaurants[randomNotif];

    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, data);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}