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
        var size = MediaQuery.of(context).size;
        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        // Here the height of the container is 45% of our total height
                        height: size.height * .25,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5CEB8),
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
                                    padding: const EdgeInsets.only(top: 20, left: 10),
                                    child:  Text('Search Restaurant', style: TextStyle(fontSize: 30, fontFamily: 'Blacklist')),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                  const SizedBox(height: 50),
                  if (searchData.isEmpty)
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            children: const [
                              SizedBox(height: 60),
                              Icon(Icons.search, color: Colors.black, size: 150),
                              Text(
                                "Find Restaurant",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                    )
                  else
                    _listBuilder(state),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _listBuilder(SearchProvider state) {
    if (state.state == ResultState.Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.state == ResultState.HasData) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: state.result.restaurants.length,
        itemBuilder: (context, index) {
          return CardSearch(restaurant: state.result.restaurants[index]);
        },
      );
    } else if (state.state == ResultState.NoData) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
            child: Column(
          children: const [
            SizedBox(height: 60),
            Icon(Icons.error_outline, color: Colors.black, size: 150),
            Text(
              "Cannot Find Restaurant",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ],
        )),
      );
    } else if (state.state == ResultState.Error) {
      return Column(children: [
        const SizedBox(height: 50),
        const Icon(
          Icons.error_outline,
          size: 150,
          color: Colors.black,
        ),
        Center(
          child: Text(state.message,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
              )),
        )
      ]);
    }else {
      return Center(child: Text(''));
    }
  }
}
