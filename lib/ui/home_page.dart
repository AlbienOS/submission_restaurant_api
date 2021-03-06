
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/ui/favorite_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_detail_page.dart';
import 'package:submission_restaurant_api/ui/restaurant_list_page.dart';
import 'package:submission_restaurant_api/ui/search_page.dart';
import 'package:submission_restaurant_api/ui/setting_page.dart';
import 'package:submission_restaurant_api/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _selectedPage = 0;
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
      icon: Icon(Icons.home),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: _searchText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: _settingsText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: _listFavoriteText,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Scaffold(
      body: _listWidget[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
        unselectedItemColor: Colors.black45,
        selectedItemColor: Colors.blueAccent,
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
    return _buildBottomNavigation(context);
  }
}
