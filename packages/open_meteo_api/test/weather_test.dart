import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather', () {
        expect(
          Weather.fromJson(<String, dynamic>{
            'temperature': 15.6,
            'weathercode': 63,
          }),
          isA<Weather>()
              .having((p0) => p0.temperature, 'temperature', 15.6)
              .having((p0) => p0.weatherCode, 'weatherCode', 63),
        );
      });
    });
  });
}
