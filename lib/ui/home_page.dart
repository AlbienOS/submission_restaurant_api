import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/ui/favorite_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_detail_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_list_page.dart';
import 'package:submission_restaurant_api/ui/search_page.dart';
import 'package:submission_restaurant_api/ui/setting_page.dart';
import 'package:submission_restaurant_api/utils/notification_helper.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Home';
  static const String _searchText = 'Search';
  static const String _listFavoriteText = 'Favorite';
  static const String _settingsText = 'Favorite';

  List<Widget> _listWidget = [
    RestaurantListPage(),
    SearchPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.search : Icons.search),
      label: _searchText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite),
      label: _settingsText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: _listFavoriteText,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
    );
  }
}
