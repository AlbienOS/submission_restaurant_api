import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/model/restaurant.dart';
import 'package:submission_restaurant_api/data/provider/favorite_restaurant_provider.dart';
import 'package:submission_restaurant_api/ui/restaurant_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurant({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteRestaurantsProvider>(
        builder: (context, provider, child) {
          return FutureBuilder<bool>(
            future: provider.isFavorited(restaurant.id),
            builder: (context, snapshot) {
              var isFavorited = snapshot.data ?? false;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(20),
                ),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                            tag: restaurant.pictureId!,
                            child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/medium/${restaurant
                                    .pictureId}')),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          restaurant.name,
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.add_location),
                                Text(
                                  restaurant.city,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.star_rounded,
                                  size: 25,
                                ),
                                Text(
                                  '${restaurant.rating}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                      isFavorited ? Icons.favorite_rounded
                                          : Icons.favorite_outline_rounded,
                                      color: Colors.red),
                                  onPressed: () {
                                    isFavorited
                                        ? provider.removeFavorite(restaurant.id)
                                        : provider.addFavorite(restaurant);
                                  },
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () =>
                      Navigator.pushNamed(
                          context, RestaurantDetailPage.routeName,
                          arguments: restaurant.id),
                ),
              );
            },
          );
        });
  }
}
