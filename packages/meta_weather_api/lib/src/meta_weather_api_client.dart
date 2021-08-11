import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta_weather_api/meta_weather_api.dart';

class MetaWeatherApiClient {
  MetaWeatherApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'www.metaweather.com';
  final http.Client _httpClient;

  /// Finds a [Location] `/api/location/search/?query=(query)`.
  Future<Location> locationSearch(String query) async {
    final request = Uri.https(
      _baseUrl,
      '/api/location/search',
      <String, String>{'query': query},
    );
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final json = jsonDecode(response.body);

    return Location.fromJson(json);
  }

  /// Fetches [Weather] for a given [locationId].
  Future<Weather> getWeather(int locationId) async {
    final request = Uri.https(
      _baseUrl,
      '/api/location/$locationId',
    );
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw Exception();
    }

    final json = jsonDecode(response.body);

    return Weather.fromJson(json);
  }
}
