import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/provider/favorite_restaurant_provider.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:submission_restaurant_api/widget/card_restaurant.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class FavoritePage extends StatelessWidget {
  Widget _buildListFavorited() {
    return Consumer<FavoriteRestaurantsProvider>(builder: (context, state, _) {
      if (state.state == ResultState.HasData) {
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
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Align(
            alignment: Alignment.center,
              child: Column(
                children: const [
                  Text(
                    "No favorite restaurant yet",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
          ),
        );
      } else {
        return Center(child: Text('Empty'));
      }
    });
  }

  Widget _buildFavorite(BuildContext context) {
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      'Favorite Restaurant',
                      style: TextStyle(fontSize: 40, fontFamily: 'Blacklist'),
                    ),
                  ),
                ],
              ),
              _buildListFavorited(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildFavorite);
  }
}
