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
      const city = 'madrid';
      const woeid = 766273;

      test('calls locationSearch with a city', () async {
        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => metaWeatherApiClient.locationSearch(city)).called(1);
      });

      test('throws exception when locationSearch fails', () async {
        final exception = Exception('oops');
        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenThrow(exception);

        expect(() => weatherRepository.getWeather(city), throwsA(exception));
      });

      test('calls getWeather with correct city', () async {
        final location = MockLocation();
        when(() => location.woeid).thenReturn(woeid);
        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);

        try {
          await weatherRepository.getWeather(city);
        } catch (_) {}
        verify(() => metaWeatherApiClient.getWeather(woeid)).called(1);
      });

      test('throws exception when getWeather fails', () async {
        final exception = Exception('oops');
        final location = MockLocation();
        when(() => location.woeid).thenReturn(woeid);
        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => metaWeatherApiClient.getWeather(any())).thenThrow(exception);

        expect(() => weatherRepository.getWeather(city), throwsA(exception));
      });

      test('returns correct weatheron success (showers)', () async {
        final location = MockLocation();
        final weather = MockWeather();

        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn('Madrid');
        when(() => weather.weatherStateAbbr)
            .thenReturn(meta_weather_api.WeatherState.showers);
        when(() => weather.theTemp).thenReturn(40);

        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => metaWeatherApiClient.getWeather(any()))
            .thenAnswer((_) async => weather);

        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const Weather(
            location: 'Madrid',
            temperature: 40,
            condition: WeatherCondition.rainy,
          ),
        );
      });

      test('returns correct weatheron success (heavyCloud)', () async {
        final location = MockLocation();
        final weather = MockWeather();

        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn('Madrid');
        when(() => weather.weatherStateAbbr)
            .thenReturn(meta_weather_api.WeatherState.heavyCloud);
        when(() => weather.theTemp).thenReturn(40);

        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => metaWeatherApiClient.getWeather(any()))
            .thenAnswer((_) async => weather);

        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const Weather(
            location: 'Madrid',
            temperature: 40,
            condition: WeatherCondition.cloudy,
          ),
        );
      });

      //don't understand why coverage needs lightCloud and heavyCloud to cover 100%
      test('returns correct weatheron success (lightCloud)', () async {
        final location = MockLocation();
        final weather = MockWeather();

        when(() => location.woeid).thenReturn(woeid);
        when(() => location.title).thenReturn('Madrid');
        when(() => weather.weatherStateAbbr)
            .thenReturn(meta_weather_api.WeatherState.lightCloud);
        when(() => weather.theTemp).thenReturn(40);

        when(() => metaWeatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => metaWeatherApiClient.getWeather(any()))
            .thenAnswer((_) async => weather);

        final actual = await weatherRepository.getWeather(city);
        expect(
          actual,
          const Weather(
            location: 'Madrid',
            temperature: 40,
            condition: WeatherCondition.cloudy,
          ),
        );
      });
    });
  });
}
