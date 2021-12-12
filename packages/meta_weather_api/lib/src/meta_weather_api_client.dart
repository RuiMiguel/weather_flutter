import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta_weather_api/meta_weather_api.dart';

class LocationRequestFailure implements Exception {}

class LocationNotFoundFailure implements Exception {}

class WeatherRequestFailure implements Exception {}

class WeatherNotFoundFailure implements Exception {}

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
    final response = await _httpClient.get(
      request,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET',
      },
    );

    if (response.statusCode != 200) {
      throw LocationRequestFailure();
    }

    final json = jsonDecode(response.body) as List;

    if (json.isEmpty) {
      throw LocationNotFoundFailure();
    }

    return Location.fromJson(json.first as Map<String, dynamic>);
  }

  /// Fetches [Weather] for a given [locationId].
  Future<Weather> getWeather(int locationId) async {
    final request = Uri.https(
      _baseUrl,
      '/api/location/$locationId',
    );
    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WeatherRequestFailure();
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json.isEmpty) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = json['consolidated_weather'] as List;

    if (weatherJson.isEmpty) {
      throw WeatherNotFoundFailure();
    }

    return Weather.fromJson(weatherJson.first as Map<String, dynamic>);
  }
}
