import 'package:bloc_weather/theme/cubit/theme_cubit.dart';
import 'package:bloc_weather/weather/screen/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _weatherRepository,
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: const WeatherAppView(),
      ),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ThemeCubit, Color>(builder: (context, color) {
      return MaterialApp(
        theme: ThemeData(
          primaryColor: color,
          textTheme: GoogleFonts.rajdhaniTextTheme(),
          appBarTheme: AppBarTheme(
            titleTextStyle: GoogleFonts.rajdhaniTextTheme(theme.textTheme)
                .apply(bodyColor: Colors.white)
                .titleLarge,
          ),
        ),
        home: const WeatherScreen(),
      );
    });
  }
}
