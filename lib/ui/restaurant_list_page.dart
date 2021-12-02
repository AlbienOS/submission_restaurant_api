import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/provider/restaurant_provider.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:submission_restaurant_api/widget/card_restaurant.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';


  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid);
  }

  Widget _buildAndroid(BuildContext context){
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:15, top: 30, bottom: 10),
                        child: Text(
                          'Restaurant',
                          style: TextStyle(fontSize: 60, fontFamily: 'Blacklist'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15, top: 10,bottom: 20),
                        child: Text(
                          'Recommendation restaurant for you!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  _buildList(),
                ],
              ),
          ),
        ),
    );
  }

  Widget _buildList(){
    return Consumer<RestaurantsProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        );
      } else if (state.state == ResultState.HasData) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: state.result.restaurants.length,
          itemBuilder: (context, index) {
            var restaurant = state.result.restaurants[index];
            return CardRestaurant(restaurant: restaurant);
          },
        );
      } else if (state.state == ResultState.NoData) {
        return Center(child: Text(state.message));
      } else if (state.state == ResultState.Error) {
        return Center(child: Text(state.message));
      } else {
        return Center(child: Text(''));
      }
    });
  }


}
