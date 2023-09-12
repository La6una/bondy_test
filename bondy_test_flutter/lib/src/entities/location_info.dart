import 'package:equatable/equatable.dart';

class LocationInfo extends Equatable {
  final String name;
  final int iconId;
  final String weather;
  final double temperature;

  LocationInfo({
    required this.name,
    required this.iconId,
    required this.weather,
    required this.temperature,
  });

  String get getName => name;
  int get getIcon => iconId;
  String get getWeather => weather;
  double get getTemperature => temperature;

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
    name: json['name'],
    iconId: json['current']['icon_num'] as int,
    weather: json['current']['summary'],
    temperature: json['current']['temperature'],
  );

  LocationInfo copyWith({
    String? name,
    int? iconId,
    String? weather,
    double? temperature,
  }) =>
      LocationInfo(
        name: name ?? this.name,
        iconId: iconId ?? this.iconId,
        weather: weather ?? this.weather,
        temperature: temperature ?? this.temperature,
      );

  @override
  List<Object?> get props => [name, iconId, weather, temperature];
}
