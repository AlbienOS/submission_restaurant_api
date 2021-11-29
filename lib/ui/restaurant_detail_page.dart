import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/model/detail_restaurant.dart';
import 'package:submission_restaurant_api/data/provider/detail_restaurant_provider.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:submission_restaurant_api/widget/platform_widget.dart';

class RestaurantDetailPage extends StatefulWidget{
  static const routeName = '/restaurant_detail';

  final String id;

  RestaurantDetailPage({required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Widget _buildDetail(){
    return Scaffold(
      body: ChangeNotifierProvider<DetailRestaurantsProvider>(
        create: (_) => DetailRestaurantsProvider(id: widget.id, apiService: ApiService()),
        child: Consumer<DetailRestaurantsProvider>(
          builder: (context, state, _) {
            if(state.state == ResultState.Loading){
              return Center(child:  CircularProgressIndicator());
            }else if(state.state == ResultState.HasData){
              var detailRestaurant = state.result.restaurant;
              return _buildDetailPage(detailRestaurant);
            }else if(state.state == ResultState.NoData){
              return Center(child: Text(state.message));
            }else if(state.state == ResultState.Error){
              return Center(child: Text(state.message));
            }else{
              return Center(child: Text(''));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailPage(DetailRestaurant detailRestaurant){
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: detailRestaurant.pictureId,
                    child: Image.network('https://restaurant-api.dicoding.dev/images/medium/${detailRestaurant.pictureId}'),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: IconButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              onPressed: (){
                                Share.share('Kunjungi ${detailRestaurant.name}, \n di daerah ${detailRestaurant.city}, dan nikmati makanan dengan kualitas ${detailRestaurant.rating}!');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        detailRestaurant.name,
                        style: TextStyle(
                          fontFamily: 'Blacklist',
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.add_location),
                            Text(
                              detailRestaurant.city,
                              style: TextStyle(
                                fontSize: 18,
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
                            Text(
                              '${detailRestaurant.rating}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _restoCategory(context, detailRestaurant.categories),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          detailRestaurant.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60, width: 30),
                  Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menu',
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Staatliches'
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Table(
                columnWidths: {1: FractionColumnWidth(0.5)},
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Foods',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Drinks',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(children: [
                    Column(
                      children: [
                        _foodItems(context, detailRestaurant.menus.foods)
                      ],
                    ),
                    Column(
                      children: [
                        _drinkItems(context, detailRestaurant.menus.drinks)
                      ],
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodItems(BuildContext context, List<Category> foods) {
    List<Widget> text = [];
    int num = 1;

    for (var foods in foods) {
      text.add(const SizedBox(
        height: 5,
      ));
      text.add(Text('$num. ${foods.name}'));
      num++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text,
    );
  }

  Widget _drinkItems(BuildContext context, List<Category> drinks) {
    List<Widget> text = [];
    int num = 1;

    for (var drinks in drinks) {
      text.add(const SizedBox(
        height: 5,
      ));
      text.add(Text('$num. ${drinks.name}'));
      num++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text,
    );
  }

  Widget _restoCategory(BuildContext context, List<Category> category){
    List<Widget> text = [];

    for(var category in category){
      text.add(const SizedBox(height: 5,));
      text.add(
          Card(
            shadowColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Icon(Icons.tag),
                  Text('${category.name}',
                  style: TextStyle(fontFamily: 'Staatliches', fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: text,
      ),
    );
  }

  Widget _buildAndroid(BuildContext context){
    return _buildDetail();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid);
  }
}