import 'dart:convert';
import 'package:bondy_test_flutter/src/blocs/cubit/locations_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../entities/location.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _isSearching = false;
  int _currentLocationIndex = 0;

  // API Key
  final String apiKey = '163lyuzif8ptzefn8zy7ejpj0rqja60fp2upcths';

  // Controllers
  TextEditingController _searchController = TextEditingController();
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final locationCubit = context.watch<LocationsCubit>();

    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: _isSearching
          ? getAppBarSearching(_searchController, locationCubit)
          : getAppBarNotSearching(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CarouselSlider.builder(
                    itemCount: locationCubit.state.howManyLocations,
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      height: 500,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentLocationIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIdx) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              // Name of the Location
                              locationCubit.state.locations[index].getName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                                'assets/icons/${locationCubit.state.locations[index].getIcon}.png'),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              locationCubit.state.locations[index].getWeather,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              // Temperature of the Location
                              '${locationCubit.state.locations[index].getTemperature} ºC',
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    locationCubit.state.locations.asMap().entries.map((entry) {
                  return GestureDetector(
                    // Allows you to go to the desired destination
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_currentLocationIndex == entry.key
                                  ? 0.9
                                  : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBarNotSearching() {
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text("Look for new Locations"),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        )
      ],
    );
  }

  PreferredSizeWidget getAppBarSearching(
      TextEditingController searchController, LocationsCubit locationsCubit) {
    return AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _isSearching = false;
          });
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: const InputDecoration(
              label: Text('Search for new Locations'),
            ),
            onChanged: (value) {},
          ),
          suggestionsCallback: (String pattern) async {
            final locations = await _getLocationByPrefix(pattern);
            return locations;
          },
          itemBuilder: (context, Location suggestion) {
            return ListTile(
              title: Text('${suggestion.getName}, ${suggestion.getCountry}'),
            );
          },
          onSuggestionSelected: (Location suggestion) {
            locationsCubit.addLocation(suggestion, apiKey);
            setState(() {
              _isSearching = false;
            });
          },
        ),
      ),
    );
  }

  Future<List<Location>> _getLocationByPrefix(String prefix) async {
    final response = await http.get(
      // We do the api request
      Uri(
        scheme: 'https',
        host: 'www.meteosource.com',
        path: '/api/v1/free/find_places_prefix',
        queryParameters: {
          'text': prefix,
          'language': 'en',
          'key': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      // In case of success
      final List<dynamic> data = json.decode(response.body);
      List<Location> locations = data
          .map((item) => Location(
                locationId: item['place_id'],
                name: item['name'],
                country: item['country'],
              ))
          .toList();
      locations.sort((a, b) => a.name.compareTo(b.name));
      return locations;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }
}
