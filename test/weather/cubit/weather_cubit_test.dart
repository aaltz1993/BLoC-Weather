import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

import '../../helper/hydrated_bloc.dart';

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  initHydratedStorage();

  group('WeatherCubit', () {
    late weather_repository.Weather weather;
    late weather_repository.WeatherRepository weatherRepository;
    late WeatherCubit weatherCubit;

    setUp(() async {
      weather = MockWeather();
      when(() => weather.location).thenReturn('London');
      when(() => weather.condition)
          .thenReturn(weather_repository.WeatherCondition.rainy);
      when(() => weather.temperature).thenReturn(10.2);

      weatherRepository = MockWeatherRepository();
      when(() => weatherRepository.getWeather(any()))
          .thenAnswer((_) async => weather);

      weatherCubit = WeatherCubit(weatherRepository);
    });

    test('has default weather state when constructor', () {
      expect(
        WeatherCubit(weatherRepository).state,
        WeatherState(weather: Weather.empty),
      );
    });

    group('fromJson/toJson', () {});

    group('fetchWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is null',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is empty',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(''),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getWeather when city is valid',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather('London'),
        verify: (_) {
          verify(
            () => weatherRepository.getWeather('London'),
          ).called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, failure] when getWeather throws',
        setUp: () {
          when(
            () => weatherRepository.getWeather(any()),
          ).thenThrow(
            Exception(':('),
          );
        },
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather('London'),
        expect: () => <WeatherState>[
          WeatherState(loadState: LoadState.loading, weather: Weather.empty),
          WeatherState(
            loadState: LoadState.failure,
            weather: Weather.empty.copyWith(location: 'London'),
          )
        ],
      );

      const location = 'London';
      const weatherCondition = WeatherCondition.rainy;
      const temperature = Temperature(10.2);

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather succeeded',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(location),
        expect: () => <dynamic>[
          WeatherState(loadState: LoadState.loading, weather: Weather.empty),
          isA<WeatherState>()
              .having((p0) => p0.loadState, 'loadState', LoadState.success)
              .having(
                (p0) => p0.weather,
                'weather',
                isA<Weather>()
                    .having((p0) => p0.location, 'location', location)
                    .having((p0) => p0.condition, 'weather_condition',
                        weatherCondition)
                    .having((p0) => p0.temperature, 'temperature', temperature)
                    .having((p0) => p0.updatedAt, 'updated_at', isNotNull),
              ),
        ],
      );
    });
  });
}
