import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/model/restaurant.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';


class RestaurantsProvider extends ChangeNotifier{
  final ApiService apiService;

  RestaurantsProvider({required this.apiService}){
    _fetchAllRestaurant();
  }

  late RestaurantResult _restaurantsResult;
  late ResultState _state;
  String _message = '';
  String get message => _message;

  RestaurantResult get result => _restaurantsResult;

  ResultState get state => _state;


  Future<dynamic> _fetchAllRestaurant() async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.topHeadlines();
      if(restaurant.restaurants.isEmpty){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    } catch (e){
      _state = ResultState.Error;
      notifyListeners();
      return _message ='No Cennection';
    }
  }
}