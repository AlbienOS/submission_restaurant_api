import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:submission_restaurant_api/data/model/detail_restaurant.dart';
import 'package:submission_restaurant_api/data/model/restaurant.dart';
import 'package:submission_restaurant_api/data/model/search_restaurant.dart';

class ApiService{
  static const String _baseUrl ='https://restaurant-api.dicoding.dev/';
  static const search = _baseUrl + 'search?q=';
  static const list = _baseUrl + 'list';


  Future<RestaurantResult> topHeadlines() async{
    final response = await http.get(Uri.parse(list));
    if(response.statusCode == 200){
      return RestaurantResult.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load top headlines');
    }
  }

  Future<DetailRestaurantsResult> topDetail(id) async{
    final response = await http.get(Uri.parse(_baseUrl + 'detail/' + id));
    if(response.statusCode == 200){
      return DetailRestaurantsResult.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load detail');
    }
  }


  Future<SearchResult> searchRestaurant(name) async{
      final response = await http.get(Uri.parse(search + name));
      if(response.statusCode == 200){
        return SearchResult.fromJson(json.decode(response.body));
      }else{
        throw Exception('Failed to load search');
      }
  }

  Future<Restaurant> randomRestaurant() async{
    var result = await ApiService().topHeadlines();
    var randomNotif = Random().nextInt(result.restaurants.length);
    var data = result.restaurants[randomNotif];
    return data;
  }
}


