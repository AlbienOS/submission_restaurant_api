import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:submission_restaurant_api/data/model/restaurant.dart';
import 'package:submission_restaurant_api/data/provider/api_provider.dart';

void main(){
  group('Group of Restaurant Testing', () {
    test('Testing Restaurant 1 ', () async{
      //arrange
      //saya menggunakan package http karena paling mudah untuk di'mock' dan diujikanya.
      Future<http.Response> _mockRequest(http.Request request) async{
        if(request.url.toString().startsWith('https://restaurant-api.dicoding.dev/list')){
          return http.Response(
              '''{
          "id" : "s1knt6za9kkfw1e867", 
          "name" : "Kafe Kita", 
          "city" : "Gorontalo", 
          "description" : "Quisque rutrum. Aenean imperdiet.", 
          "pictureId" : "25", 
          "rating" : 4
          }''', 200);
        }
        return http.Response('Error', 404);
      }
      //act
      final apiProvider = ApiProvider(MockClient(_mockRequest));
      final resto = await apiProvider.getData();

      //assert
      expect(resto.id, 's1knt6za9kkfw1e867');
      expect(resto.name, 'Kafe Kita');
      expect(resto.city, 'Gorontalo');
      expect(resto.description, 'Quisque rutrum. Aenean imperdiet.');
      expect(resto.pictureId, '25');
      expect(resto.rating, 4);

    });

    test('Testing Restaurant 2',() {
      //ambil data dari dataclass restaurant
      final restaurant = Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2
      );
      //expect
      expect(restaurant.id, 'rqdv5juczeskfw1e867');
      expect(restaurant.name, 'Melting Pot');
      expect(restaurant.description, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.');
      expect(restaurant.pictureId, '14');
      expect(restaurant.city, 'Medan');
      expect(restaurant.rating, 4.2);
    });
    });
}