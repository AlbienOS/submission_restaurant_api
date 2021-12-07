import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/model/detail_restaurant.dart';
import 'package:submission_restaurant_api/data/provider/detail_restaurant_provider.dart';
import 'package:submission_restaurant_api/ui/home_page.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: detailRestaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                        child: Image.network('https://restaurant-api.dicoding.dev/images/medium/${detailRestaurant.pictureId}'),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                              },
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
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
                  _restoCategory(context, detailRestaurant.categories),
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
                  Divider(color: Colors.grey, thickness: 4,),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Makanan :',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Staatliches'
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [_foodItems(context, detailRestaurant.menus.foods)]
              ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Minuman :',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Staatliches'
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.100,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [_drinkItems(context, detailRestaurant.menus.drinks)]
                ),
              ),
        ],
        ),
      ),
    ),
    );
  }

  Widget _foodItems(BuildContext context, List<Category> foodsList) {
    List<Widget> foodText = [];

    for (var foods in foodsList) {
      foodText.add(Padding(padding: EdgeInsets.all(8),

      ));
      foodText.add(
          Card(
            shadowColor: Colors.black,
            color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        width: 200,
                        child: Center(
                          child: Text('${foods.name}', style: TextStyle(fontFamily: 'Staatliches'),
                          ),
                        ),
                    ),
                  ),
                ],
              ),
          ),
      );
    }
    return  Row(
        children: foodText
      );
  }

  Widget _drinkItems(context, List<Category> drinksList) {
    List<Widget> drinkText = [];

    for (var drinks in drinksList) {
      drinkText.add(
          Padding(padding: EdgeInsets.all(8)
      ));
      drinkText.add(
        Card(
        shadowColor: Colors.black,
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: 200,
                child: Center(
                  child: Text('${drinks.name}', style: TextStyle(fontFamily: 'Staatliches')
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      );
    }
    return Row(
      children: drinkText
    );
  }

  Widget _restoCategory(context, List<Category> category){
    List<Widget> text = [];

    for(var category in category){
      text.add(Padding(padding: EdgeInsets.all(8.0)));
      text.add(
          Card(
            shadowColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
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