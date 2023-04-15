import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
        title: const Text('Bloc Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.search_rounded,
          semanticLabel: 'Search',
        ),
        onPressed: () async {},
      ),
    );
  }
}
