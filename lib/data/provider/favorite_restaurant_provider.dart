import 'package:flutter/cupertino.dart';
import 'package:submission_restaurant_api/data/db/database_helper.dart';
import 'package:submission_restaurant_api/data/model/restaurant.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';


class FavoriteRestaurantsProvider extends ChangeNotifier{
  final DatabaseHelper databaseHelper;

  FavoriteRestaurantsProvider({required this.databaseHelper}){
    _getFavorite();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorite = [];
  List<Restaurant> get favorite => _favorite;

  void _getFavorite() async{
    _favorite = await databaseHelper.getFavorite();
    if(_favorite.length > 0){
      _state = ResultState.HasData;
    }else{
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addtoFavorite(Restaurant restaurant) async{
    try{
      await databaseHelper.insertFavorite(restaurant);
      _getFavorite();
    }catch(e){
      _state = ResultState.Error;
      _message = 'Error: Failed to Add Favorite Cause Lost Connection!';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async{
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async{
    try{
      await databaseHelper.removeFavorite(id);
      _getFavorite();
    }catch(e){
      _state = ResultState.Error;
      _message = 'Error: Failed Remove Favorite!';
      notifyListeners();
    }
  }
}