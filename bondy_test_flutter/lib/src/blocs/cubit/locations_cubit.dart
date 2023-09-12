import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../entities/location.dart';
import '../../entities/location_info.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(const LocationsState());

  Future<void> addLocation(Location newLocation, String apiKey) async {
    final response = await http.get(
      // We do the api request
      Uri(
        scheme: 'https',
        host: 'www.meteosource.com',
        path: '/api/v1/free/point',
        queryParameters: {
          'place_id': newLocation.getLocationId,
          'units': 'metric',
          'language': 'en',
          'key': apiKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      // In case of success
      final Map<String, dynamic> data = json.decode(response.body);
      final jsonMap = {
        "name": newLocation.getName,
        "current": {
          "icon_num": data['current']['icon_num'], 
          "summary": data['current']['summary'], 
          "temperature": data['current']['temperature'], 
        },
      };

      final newLocationInfo = LocationInfo.fromJson(jsonMap);
      emit(state.copyWith(locations: [...state.locations, newLocationInfo]));
    } else {
      // In case of error
      throw Exception('Failed to load location');
    }

    Future<void> updateLocation(LocationInfo location, String apiKey) async {
      final response = await http.get(
        // We do the api request
        Uri(
          scheme: 'https',
          host: 'www.meteosource.com',
          path: '/api/v1/free/point',
          queryParameters: {
            'place_id': location.getName,
            'units': 'metric',
            'language': 'en',
            'key': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        // In case of success
        final Map<String, dynamic> data = json.decode(response.body);
        final jsonMap = {
          "name": location.getName,
          "current": {
            "icon_num": data['current']['icon_num'], 
            "summary": data['current']['summary'], 
            "temperature": data['current']['temperature'], 
          },
        };

        final newLocationInfo = LocationInfo.fromJson(jsonMap);
        emit(state.copyWith(locations: [...state.locations, newLocationInfo]));
      } else {
        // In case of error
        throw Exception('Failed to load location');
      }
    }
    
  }

  
}
