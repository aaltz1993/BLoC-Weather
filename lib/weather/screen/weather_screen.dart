import 'package:bloc_weather/search/search.dart';
import 'package:bloc_weather/settings/screen/settings_screen.dart';
import 'package:bloc_weather/theme/theme.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(context.read<WeatherRepository>()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                SettingsScreen.route(
                  context.read<WeatherCubit>(),
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.loadState == LoadState.success) {
              context.read<ThemeCubit>().updateTheme(state.weather);
            }
          },
          builder: (context, state) {
            switch (state.loadState) {
              case LoadState.none:
                return const WeatherEmpty();
              case LoadState.loading:
                return const WeatherLoading();
              case LoadState.success:
                return WeatherPopulated(
                  weather: state.weather,
                  temperatureUnit: state.temperatureUnit,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                );
              case LoadState.failure:
                return const WeatherError();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.search_rounded,
          semanticLabel: 'Search',
        ),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchScreen.route());

          if (!mounted) return;

          await context.read<WeatherCubit>().fetchWeather(city);
        },
      ),
    );
  }
}
