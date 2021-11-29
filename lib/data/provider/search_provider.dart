import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/model/search_restaurant.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';


class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService, required this.name}){
    _fetchSearch(name);
  }
  late SearchResult _restaurantsResult;
  late ResultState _state;
  String _message = '';
  String name = '';
  String get message => _message;

  SearchResult get result => _restaurantsResult;

  ResultState get state => _state;

  Future<dynamic> _fetchSearch(String name) async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.searchRestaurant(name);
      if(restaurant.restaurants.isEmpty){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    }catch(e){
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'No Connection';
    }
  }

  void searchResto(String name){
    notifyListeners();
    _fetchSearch(name);
  }
}

