
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/provider/preferences_provider.dart';
import 'package:submission_restaurant_api/data/provider/scheduling_provider.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class SettingsPage extends StatelessWidget{
  static const String settingsTittle = "settings";

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
    );
  }
}

Widget _buildAndroid(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Settings'),
    ),
    body: Consumer<PreferencesProvider>(builder: (context, provider, child){
      return ListView(
        children: [
          Material(
            child: ListTile(
              title: Text('Restaurant Notify'),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, _){
                  return Switch.adaptive(
                      value: provider.isDailyRestaurant,
                      onChanged: (value) async{
                        scheduled.scheduledRestaurant(value);
                        provider.enableDailyRestaurant(value);
                      }
                  );
                },
              ),
            ),
          ),
        ],
      );
    },
    ),
  );
}

