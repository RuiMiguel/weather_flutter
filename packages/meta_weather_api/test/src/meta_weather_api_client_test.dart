import 'package:http/http.dart' as http;
import 'package:meta_weather_api/meta_weather_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('MetaWeatherApiClient', () {
    late http.Client httpClient;
    late MetaWeatherApiClient metaWeatherApiClient;

    setUp(() => () {
          httpClient = MockHttpClient();
          metaWeatherApiClient = MetaWeatherApiClient(httpClient: httpClient);
        });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(MetaWeatherApiClient(), isNotNull);
      });
    });

    group('description', () {
      test('', () {});
    });
  });
}
