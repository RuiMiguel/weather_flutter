import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

part 'weather.g.dart';

//why don't separate temperature and weather into different files
enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;

  @override
  List<Object?> get props => [value];

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}

//better to define this as extension inistead of in cubit?
extension TemperatureX on Temperature {
  Temperature get toFahrenheit => Temperature(value: (value * 9 / 5) + 32);
  Temperature get toCelsius => Temperature(value: (value - 32) * 5 / 9);
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  //why create factory method fromRepository instead of mapper extensions
  factory Weather.fromRepository(weather_repository.Weather weather) => Weather(
        condition: weather.condition,
        lastUpdated: DateTime.now(),
        location: weather.location,
        temperature: Temperature(value: weather.temperature),
      );

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    location: '--',
    temperature: const Temperature(value: 0),
  );

  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;

  @override
  List<Object?> get props => [condition, lastUpdated, location, temperature];

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
  }) =>
      Weather(
        condition: condition ?? this.condition,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        location: location ?? this.location,
        temperature: temperature ?? this.temperature,
      );
}
