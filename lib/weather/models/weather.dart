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
  const Temperature({required this.value, TemperatureUnits? units})
      : units = units ?? TemperatureUnits.celsius;

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;
  final TemperatureUnits units;

  @override
  List<Object?> get props => [value, units];

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  Temperature copyWith({
    double? value,
    TemperatureUnits? units,
  }) {
    return Temperature(
      value: value ?? this.value,
      units: units ?? this.units,
    );
  }
}

//better to define this as extension inistead of in cubit?
extension TemperatureX on Temperature {
  Temperature get toFahrenheit => Temperature(
      value: (value * 9 / 5) + 32, units: TemperatureUnits.fahrenheit);
  Temperature get toCelsius =>
      Temperature(value: (value - 32) * 5 / 9, units: TemperatureUnits.celsius);
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
  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(
          value: weather.temperature, units: TemperatureUnits.celsius),
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    location: '--',
    temperature: const Temperature(value: 0, units: TemperatureUnits.celsius),
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
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
    );
  }
}
