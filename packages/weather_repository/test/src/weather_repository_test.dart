import 'package:meta_weather_api/meta_weather_api.dart' as meta_weather_api;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class MockMetaWeatherApiClient extends Mock
    implements meta_weather_api.MetaWeatherApiClient {}

class MockLocation extends Mock implements meta_weather_api.Location {}

class MockWeather extends Mock implements meta_weather_api.Weather {}

void main() {
  group('WeatherRepository', () {
    late meta_weather_api.MetaWeatherApiClient metaWeatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      metaWeatherApiClient = MockMetaWeatherApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: metaWeatherApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal MetaWeatherApiClient when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group('getWeather', () {
      test('instantiates ', () {});
    });
  });
}
