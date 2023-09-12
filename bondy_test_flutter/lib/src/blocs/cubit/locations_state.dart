part of 'locations_cubit.dart';

class LocationsState extends Equatable {
  final List<LocationInfo> locations;

  const LocationsState({
      this.locations = const [],
  });

  int get howManyLocations => locations.length;

  LocationsState copyWith({
    List<LocationInfo>? locations,

  }) => 
    LocationsState(
      locations: locations ?? this.locations
    );

  @override
  List<Object?> get props => [locations];
}
