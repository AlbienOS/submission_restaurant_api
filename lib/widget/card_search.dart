import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/data/model/search_restaurant.dart';
import 'package:submission_restaurant_api/ui/restaurant_detail_page.dart';

class CardSearch extends StatelessWidget{
  final SearchRestaurant restaurant;

  const CardSearch({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
                tag: restaurant.pictureId,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurant
                          .pictureId}'),
                )
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(restaurant.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.add_location),
                          Text(restaurant.city,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 25,
                          ),
                          Text('${restaurant.rating}', style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context,
            RestaurantDetailPage.routeName, arguments: restaurant.id),
      ),
    );
  }
}