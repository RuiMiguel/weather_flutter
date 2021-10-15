import 'package:test/test.dart';
import 'package:weather/weather/weather.dart';

void main() {
  group('WeatherState', () {
    test('copyWith no changes', () {
      final weatherState = WeatherState();
      final copy = weatherState.copyWith();
      expect(copy.status, weatherState.status);
      expect(copy.weather, weatherState.weather);
    });

    test('copyWith changing status', () {
      final weatherState = WeatherState();
      final copy = weatherState.copyWith(status: WeatherStatus.loading);
      expect(copy.status, WeatherStatus.loading);
      expect(copy.weather, weatherState.weather);
    });

    test('copyWith changing weather', () {
      final weather = Weather(
        condition: WeatherCondition.cloudy,
        lastUpdated: DateTime.now(),
        location: 'Location',
        temperature: const Temperature(
          value: 10,
          units: TemperatureUnits.celsius,
        ),
      );
      final weatherState = WeatherState();
      final copy = weatherState.copyWith(weather: weather);
      expect(copy.status, weatherState.status);
      expect(copy.weather, weather);
    });
  });

  group('WeatherStatusX', () {
    test('returns correct values for WeatherStatus.initial', () {
      const status = WeatherStatus.initial;
      expect(status.isInitial, isTrue);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isFalse);
      expect(status.isFailure, isFalse);
    });

    test('returns correct values for WeatherStatus.loading', () {
      const status = WeatherStatus.loading;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isTrue);
      expect(status.isSuccess, isFalse);
      expect(status.isFailure, isFalse);
    });

    test('returns correct values for WeatherStatus.success', () {
      const status = WeatherStatus.success;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isTrue);
      expect(status.isFailure, isFalse);
    });

    test('returns correct values for WeatherStatus.failure', () {
      const status = WeatherStatus.failure;
      expect(status.isInitial, isFalse);
      expect(status.isLoading, isFalse);
      expect(status.isSuccess, isFalse);
      expect(status.isFailure, isTrue);
    });
  });
}
