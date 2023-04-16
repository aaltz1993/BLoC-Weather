import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<Color> {
  ThemeCubit() : super(defaultColor);

  static const defaultColor = Color(0XFF2196F3);

  @override
  Color fromJson(Map<String, dynamic> json) {
    return Color(int.parse(json['color'] as String));
  }

  @override
  Map<String, dynamic> toJson(Color state) {
    return <String, String>{'color': '${state.value}'};
  }

  void updateTheme(Weather weather) {
    emit(weather.condition.toColor);
  }
}

extension on WeatherCondition {
  Color get toColor {
    switch (this) {
      case WeatherCondition.clear:
        return Colors.orangeAccent;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.unknown:
        return ThemeCubit.defaultColor;
    }
  }
}
