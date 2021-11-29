import 'package:flutter/material.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/model/detail_restaurant.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:http/http.dart' as http;


class DetailRestaurantsProvider extends ChangeNotifier{
  final ApiService apiService;
  final String id;

  DetailRestaurantsProvider({required this.id, required this.apiService}){
    _fetchDetailRestaurant(id);
  }

  late DetailRestaurantsResult _detailResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurantsResult get result => _detailResult;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailRestaurant(String id) async{
    try{
      _state = ResultState.Loading;
      notifyListeners();
      final detailRestaurant = await apiService.topDetail(id);
      if(detailRestaurant.restaurant == null){
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      }else{
        _state = ResultState.HasData;
        notifyListeners();
        return _detailResult = detailRestaurant;
      }
    }catch (e){
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'No Connection';
    }

  }
}