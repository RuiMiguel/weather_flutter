import 'package:json_annotation/json_annotation.dart';
import 'package:meta_weather_api/meta_weather_api.dart';
import 'package:test/test.dart';

void main() {
  group('Location', () {
    group('fromJson', () {
      test('throws CheckedFromJsonException when enum is unknown', () {
        expect(
          () => Location.fromJson(<String, dynamic>{
            'title': 'mock-title',
            'location_type': 'Unknown',
            'latt_long': '-34.75,83.28',
            'woeid': 42
          }),
          throwsA(isA<CheckedFromJsonException>()),
        );
      });
    });

    group('LatLongConverter', () {
      test('toJson returns LatLng into json', () {
        final json = const LatLongConverter().toJson(
          LatLng(
            latitude: -34.75,
            longitude: 83.28,
          ),
        );
        expect(
          json,
          equals('-34.75,83.28'),
        );
      });
    });
  });
}
