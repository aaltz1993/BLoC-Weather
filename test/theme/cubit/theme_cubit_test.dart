import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_weather/theme/cubit/theme_cubit.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/hydrated_bloc.dart';

class MockWeather extends Mock implements Weather {
  MockWeather(this._condition);

  final WeatherCondition _condition;

  @override
  WeatherCondition get condition => _condition;
}

void main() {
  initHydratedStorage();

  group('ThemeCubit', () {
    test('has default color when constructor', () {
      expect(ThemeCubit().state, ThemeCubit.defaultColor);
    });

    group('fromJson/toJson', () {
      test('works properly', () {
        final themeCubit = ThemeCubit();
        expect(
          themeCubit.fromJson(themeCubit.toJson(themeCubit.state)),
          themeCubit.state,
        );
      });
    });

    group('updateTheme', () {
      blocTest<ThemeCubit, Color>(
        'emits correct color when weather condition is clear',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(MockWeather(WeatherCondition.clear)),
        expect: () => <Color>[Colors.orangeAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color when weather condition is unknown',
        build: ThemeCubit.new,
        act: (cubit) =>
            cubit.updateTheme(MockWeather(WeatherCondition.unknown)),
        expect: () => <Color>[ThemeCubit.defaultColor],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color when weather condition is cloudy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(MockWeather(WeatherCondition.cloudy)),
        expect: () => <Color>[Colors.blueGrey],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color when weather condition is rainy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(MockWeather(WeatherCondition.rainy)),
        expect: () => <Color>[Colors.indigoAccent],
      );

      blocTest<ThemeCubit, Color>(
        'emits correct color when weather condition is snowy',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(MockWeather(WeatherCondition.snowy)),
        expect: () => <Color>[Colors.lightBlueAccent],
      );
    });
  });
}
