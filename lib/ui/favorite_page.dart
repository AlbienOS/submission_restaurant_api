import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/provider/favorite_restaurant_provider.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:submission_restaurant_api/widget/card_restaurant.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class FavoritePage extends StatelessWidget {
  Widget _buildList() {
    return Consumer<FavoriteRestaurantsProvider>(builder: (context, state, _) {
      if (state.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.HasData) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: state.favorite.length,
          itemBuilder: (context, index) {
            var restaurant = state.favorite[index];
            return CardRestaurant(restaurant: restaurant);
          },
        );
      } else if (state.state == ResultState.NoData) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
              child: Column(
                children: const [
                  SizedBox(height: 60),
                  Icon(Icons.error_outline, color: Colors.black, size: 150),
                  Text(
                    "No favorite restaurant yet",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
          ),
        );
      } else if (state.state == ResultState.Error) {
        return Column(children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.error_outline,
            size: 150,
            color: Colors.black,
          ),
          Center(
            child: Text(state.message,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                )),
          )
        ]);
      } else {
        return Center(child: Text(''));
      }
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
                    child: Text(
                      'Restaurant',
                      style: TextStyle(fontSize: 60, fontFamily: 'Blacklist'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 20),
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

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid);
  }
}
