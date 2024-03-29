import 'package:bloc_weather/weather/model/models.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepository)
      : super(WeatherState(weather: Weather.empty));

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(loadState: LoadState.loading));

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(city),
      );

      final temperatureUnit = state.temperatureUnit;

      final temperatureValue = temperatureUnit.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          loadState: LoadState.success,
          weather: weather.copyWith(temperature: Temperature(temperatureValue)),
          temperatureUnit: temperatureUnit,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          loadState: LoadState.failure,
          weather: state.weather.copyWith(location: city),
        ),
      );
    }
  }

  Future<void> refreshWeather() async {
    if (state.loadState == LoadState.none || state.weather == Weather.empty) {
      return;
    }

    emit(state.copyWith(loadState: LoadState.loading));

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(state.weather.location),
      );

      final temperatureUnit = state.temperatureUnit;

      final temperatureValue = temperatureUnit.isFahrenheit
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          loadState: LoadState.success,
          weather: weather.copyWith(temperature: Temperature(temperatureValue)),
          temperatureUnit: temperatureUnit,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          loadState: LoadState.failure,
          weather: Weather.empty,
        ),
      );
    }
  }

  void toggleTemperatureUnit() {
    final temperatureUnit = state.temperatureUnit.isFahrenheit
        ? TemperatureUnit.celsius
        : TemperatureUnit.fahrenheit;

    if (state.loadState != LoadState.success ||
        state.weather == Weather.empty) {
      emit(state.copyWith(temperatureUnit: temperatureUnit));
      return;
    }

    final temperature = state.weather.temperature;
    final temperatureValue = temperatureUnit.isCelsius
        ? temperature.value.toCelsius()
        : temperature.value.toFahrenheit();

    emit(
      state.copyWith(
        weather: state.weather.copyWith(
          temperature: Temperature(temperatureValue),
        ),
        temperatureUnit: temperatureUnit,
      ),
    );
  }
}

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;
}
