import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

class OpenMeteoApiClient {
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _weatherBaseURL = 'api.open-meteo.com';
  static const _geocodingBaseURL = 'geocoding-api.open-meteo.com';

  Future<Location> searchLocation(String query) async {
    final request = Uri.https(_geocodingBaseURL, '/v1/search', {
      'name': query,
      'count': '1',
    });

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw LocationRequestFailedException();
    }

    final json = jsonDecode(response.body) as Map;

    if (!json.containsKey('results')) throw LocationNotFoundException();

    final results = json['results'] as List;

    if (results.isEmpty) throw LocationNotFoundException();

    return Location.fromJson(results.first as Map<String, dynamic>);
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final request = Uri.https(_weatherBaseURL, 'v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
    });

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) throw WeatherRequestFailedException();

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (!json.containsKey('current_weather')) throw WeatherNotFoundException();

    return Weather.fromJson(json['current_weather'] as Map<String, dynamic>);
  }
}

class LocationRequestFailedException implements Exception {}

class LocationNotFoundException implements Exception {}

class WeatherRequestFailedException implements Exception {}

class WeatherNotFoundException implements Exception {}
