import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

enum LocationType {
  @JsonValue('City')
  city,
  @JsonValue('Region')
  region,
  @JsonValue('State')
  state,
  @JsonValue('Province')
  province,
  @JsonValue('Country')
  country,
  @JsonValue('Continent')
  continent,
}

@JsonSerializable()
class Location {
  Location({
    required this.title,
    required this.locationType,
    required this.latLng,
    required this.woeid,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  final String title;
  final LocationType locationType;
  @JsonKey(name: 'latt_long') //different json key from field name
  @LatLongConverter() //Converter for json string value into LatLng object
  final LatLng latLng;
  final int woeid;
}

class LatLng {
  LatLng({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class LatLongConverter implements JsonConverter<LatLng, String> {
  const LatLongConverter();

  @override
  LatLng fromJson(String json) {
    final parts = json.split(',');
    return LatLng(
      latitude: double.tryParse(parts[0]) ?? 0,
      longitude: double.tryParse(parts[1]) ?? 0,
    );
  }

  @override
  String toJson(LatLng latlng) {
    return '${latlng.latitude},${latlng.longitude}';
  }
}
