// ignore_for_file: lines_longer_than_80_chars

import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('Open-Meteo API Client', () {
    late http.Client httpClient;
    late OpenMeteoApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = OpenMeteoApiClient(httpClient: httpClient);
    });

    // constructor
    group('Constructor', () {
      test('does not require http.Client', () {
        expect(OpenMeteoApiClient(), isNotNull);
      });
    });

    // search location
    group('Search Location', () {
      const query = 'mock-query';

      test('makes correct http.Request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        try {
          await apiClient.searchLocation(query);
        } catch (_) {/* ... */}

        verify(
          () => httpClient.get(
            Uri.https(
              'geocoding-api.open-meteo.com',
              'v1/search',
              {'name': query, 'count': '1'},
            ),
          ),
        ).called(1);
      });

      test('throws LocationRequestFailedException on non-200 response', () {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        expect(
          () async => apiClient.searchLocation(query),
          throwsA(isA<LocationRequestFailedException>()),
        );
      });

      test('throws LocationNotFoundException on wrong response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        await expectLater(
          apiClient.searchLocation(query),
          throwsA(isA<LocationNotFoundException>()),
        );
      });

      test('throws LocationNotFoundException on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        await expectLater(
          apiClient.searchLocation(query),
          throwsA(isA<LocationNotFoundException>()),
        );
      });

      test('returns Location on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('''
            {
              "results": [{
                "id": 4887398,
                "name": "Chicago",
                "latitude": 41.85003,
                "longitude": -87.65005
              }]
            }
            ''');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);

        final actual = await apiClient.searchLocation(query);

        expect(
          actual,
          isA<Location>()
              .having((p0) => p0.id, 'id', 4887398)
              .having((p0) => p0.name, 'name', 'Chicago')
              .having((p0) => p0.latitude, 'latitude', 41.85003)
              .having((p0) => p0.longitude, 'longitude', -87.65005),
        );
      });
    });

    group('Get Weather', () {});
  });
}
