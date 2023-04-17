import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Route<void> route(WeatherCubit weatherCubit) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: weatherCubit,
        child: const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('City Search'),
        ),
        body: ListView(
          children: [
            BlocBuilder<WeatherCubit, WeatherState>(
              buildWhen: (previous, current) =>
                  previous.temperatureUnit != current.temperatureUnit,
              builder: (context, state) {
                return ListTile(
                  title: const Text('Temperature Unit'),
                  isThreeLine: true,
                  subtitle: const Text(
                    'Use metric measurement for temperature unit',
                  ),
                  trailing: Switch(
                    value: state.temperatureUnit.isCelsius,
                    onChanged: (_) =>
                        context.read<WeatherCubit>().toggleTemperatureUnit(),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
