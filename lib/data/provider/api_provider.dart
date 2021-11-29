import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:submission_restaurant_api/data/model/restaurant.dart';

class ApiProvider{
  final Client client;

  ApiProvider(this.client);

  Future<Restaurant> getData() async{
    final response = await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
    return Restaurant.fromJson(jsonDecode(response.body));
  }
}