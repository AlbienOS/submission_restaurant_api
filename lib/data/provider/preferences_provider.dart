import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant_api/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {

  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}){
    _getDailyRestaurantPreferences();
  }

  bool _isDailyRestaurant = false;
  bool get isDailyRestaurant => _isDailyRestaurant;

  void _getDailyRestaurantPreferences() async {
    _isDailyRestaurant = await preferencesHelper.isDailyRestaurant;
    notifyListeners();
  }

  void enableDailyRestaurant(bool value) {
    preferencesHelper.setRestaurant(value);
    _getDailyRestaurantPreferences();
  }

}