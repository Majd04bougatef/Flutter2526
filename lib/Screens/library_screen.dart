import 'package:flutter/material.dart';
import 'package:myapp/CustomWidgets/custom_library_card.dart';
import 'package:myapp/Models/game.dart';
import 'package:myapp/Services/game_service.dart';

class LibraryScreen extends StatefulWidget {
  static final String routeName = "/Library";

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final GameService _gameService = GameService();
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _gameService.fetchGames();
  }

  void _retry() {
    setState(() {
      _gamesFuture = _gameService.fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Game>>(
          future: _gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Failed to load library.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            final games = snapshot.data ?? const <Game>[];
            if (games.isEmpty) {
              return const Center(child: Text('No games available.'));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) => CustomLibraryCard(games[index]),
            );
          },
        ),
      ),
    );
  }
}
