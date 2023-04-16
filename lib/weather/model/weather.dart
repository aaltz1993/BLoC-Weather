import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

part 'weather.g.dart';

enum TemperatureUnit { fahrenheit, celsius }

extension TemperatureUnitsExtension on TemperatureUnit {
  bool get isFahrenheit => this == TemperatureUnit.fahrenheit;
  bool get isCelsius => this == TemperatureUnit.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature(this.value);

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  final double value;

  @override
  List<Object?> get props => [value];

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather({
    required this.location,
    required this.condition,
    required this.temperature,
    required this.updatedAt,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      location: weather.location,
      condition: weather.condition,
      temperature: Temperature(weather.temperature),
      updatedAt: DateTime.now(),
    );
  }

  static final empty = Weather(
    location: '--',
    condition: WeatherCondition.unknown,
    temperature: const Temperature(0.0),
    updatedAt: DateTime(0),
  );

  Weather copyWith({
    String? location,
    WeatherCondition? condition,
    Temperature? temperature,
    DateTime? updatedAt,
  }) {
    return Weather(
      location: location ?? this.location,
      condition: condition ?? this.condition,
      temperature: temperature ?? this.temperature,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  final String location;
  final WeatherCondition condition;
  final Temperature temperature;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [location, condition, temperature, updatedAt];
}
