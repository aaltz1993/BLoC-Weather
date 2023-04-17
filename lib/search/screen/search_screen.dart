import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchScreen());
  }

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Search'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Seoul',
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'Search',
            ),
            onPressed: () =>
                Navigator.of(context).pop(_textEditingController.text),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }
}
