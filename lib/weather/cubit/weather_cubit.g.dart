// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherState',
      json,
      ($checkedConvert) {
        final val = WeatherState(
          loadState: $checkedConvert(
              'load_state',
              (v) =>
                  $enumDecodeNullable(_$LoadStateEnumMap, v) ?? LoadState.none),
          temperatureUnit: $checkedConvert(
              'unit',
              (v) =>
                  $enumDecodeNullable(_$TemperatureUnitEnumMap, v) ??
                  TemperatureUnit.celsius),
          weather: $checkedConvert(
              'weather', (v) => Weather.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'loadState': 'load_state'},
    );

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'load_state': _$LoadStateEnumMap[instance.loadState]!,
      'weather': instance.weather.toJson(),
      'unit': _$TemperatureUnitEnumMap[instance.temperatureUnit]!,
    };

const _$LoadStateEnumMap = {
  LoadState.none: 'none',
  LoadState.loading: 'loading',
  LoadState.success: 'success',
  LoadState.failure: 'failure',
};

const _$TemperatureUnitEnumMap = {
  TemperatureUnit.fahrenheit: 'fahrenheit',
  TemperatureUnit.celsius: 'celsius',
};
