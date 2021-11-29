import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_restaurant_api/common/navigation.dart';
import 'package:submission_restaurant_api/data/db/database_helper.dart';
import 'package:submission_restaurant_api/data/preferences/preferences_helper.dart';
import 'package:submission_restaurant_api/data/provider/favorite_restaurant_provider.dart';
import 'package:submission_restaurant_api/data/provider/preferences_provider.dart';
import 'package:submission_restaurant_api/ui/home_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_detail_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_list_page.dart';
import 'package:submission_restaurant_api/ui/setting_page.dart';
import 'package:submission_restaurant_api/utils/background_service.dart';
import 'package:submission_restaurant_api/utils/notification_helper.dart';

import 'common/styles.dart';
import 'common/text_theme.dart';
import 'data/api/api_service.dart';
import 'data/provider/restaurant_provider.dart';
import 'data/provider/scheduling_provider.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>
            FavoriteRestaurantsProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (_) => RestaurantsProvider(apiService: ApiService()),
          child: RestaurantListPage(),
        ),
        ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
                preferencesHelper: PreferencesHelper(
                    sharedPreferences: SharedPreferences.getInstance()
                ),
            ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
          child: SettingsPage(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: secondColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: myTextTheme,
          appBarTheme: AppBarTheme(
            textTheme: myTextTheme.apply(bodyColor: Colors.black),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: secondColor,
              textStyle: TextStyle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
            ),
          ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
            )
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(id: ModalRoute.of(context)?.settings.arguments as String),
          //SearchPage.routeName: (context) => SearchPage(),
        },
      ),
    );
  }
}
