class Location {
  final String locationId;
  final String name;
  final String country;

  Location({
    required this.locationId,
    required this.name,
    required this.country,
  });


  get getLocationId => locationId;
  get getName => name;
  get getCountry => country;
  
}
