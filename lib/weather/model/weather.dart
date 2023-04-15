import 'package:equatable/equatable.dart';

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsExtension on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

class Temperature extends Equatable {
  final double value;

  const Temperature(this.value);

  @override
  List<Object?> get props => [value];
}

class Location extends Equatable {
  final String name;

  const Location(this.name);

  @override
  List<Object?> get props => [name];
}

class Weather {
  /*
  final Location location;
  final Temperature temperature;
  final DateTime updatedAt;
   */
}
