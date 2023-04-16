part of 'weather_cubit.dart';

enum LoadState { none, loading, success, failure }

@JsonSerializable()
class WeatherState extends Equatable {
  const WeatherState({
    this.loadState = LoadState.none,
    this.temperatureUnit = TemperatureUnit.celsius,
    required this.weather,
  });

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);

  final LoadState loadState;
  final Weather weather;
  final TemperatureUnit temperatureUnit;

  WeatherState copyWith({
    LoadState? loadState,
    Weather? weather,
    TemperatureUnit? temperatureUnit,
  }) {
    return WeatherState(
      loadState: loadState ?? this.loadState,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      weather: weather ?? this.weather,
    );
  }

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  @override
  List<Object?> get props => [loadState, weather, temperatureUnit];
}
