import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_restaurant_api/data/api/api_service.dart';
import 'package:submission_restaurant_api/data/provider/search_provider.dart';
import 'package:submission_restaurant_api/utils/result_state.dart';
import 'package:submission_restaurant_api/widget/card_search.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchData = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
      create: (_) => SearchProvider(apiService: ApiService(), name: searchData),
      child: Consumer<SearchProvider>(builder: (context, state, _) {
        var size = MediaQuery
            .of(context)
            .size;
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        // Here the height of the container is 45% of our total height
                        height: size.height * .25,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: CircleAvatar(
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Text('Search Restaurant',
                                        style: TextStyle(fontSize: 30,
                                            fontFamily: 'Blacklist')),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                padding:
                                EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(29.5),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    icon: Icon(Icons.search),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      searchData = value;
                                      state.searchResto(value);
                                      _listBuilder(state);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                    if(searchData.isEmpty)
                      Container(
                        child: Column(
                          children: [
                              SizedBox(
                                height: 400,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Find Restaurant',
                                    style: TextStyle(fontSize: 20),),
                                ),
                              ),
                          ],
                        ),
                      )
                  else
                    _listBuilder(state)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }


  Widget _listBuilder(SearchProvider state) {
    if(state.state == ResultState.HasData){
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: state.result.restaurants.length,
        itemBuilder: (context, i) {
          var restaurant = state.result.restaurants[i];
          return CardSearch(restaurant: restaurant);
        },
      );
    }else if(state.state == ResultState.Loading){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      );
    } else if(state.state == ResultState.NoData){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 100,),
              Text(state.message, style: TextStyle(fontSize: 16),),
            ],
          ),
        );
    }else if(state.state == ResultState.Error){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 100,),
            Text(state.message, style: TextStyle(fontSize: 16),),
          ],
        ),
      );
    }
    else{
      return Text('Empty');
    }
  }
}