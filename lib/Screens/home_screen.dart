import 'package:flutter/material.dart';
import 'package:myapp/CustomWidgets/custom_home_card.dart';
import 'package:myapp/Models/game.dart';
import 'package:myapp/Screens/details_screen.dart';
import 'package:myapp/Services/game_service.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = "/Home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GameService _gameService = GameService();
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = _gameService.fetchGames(limit: 10);
  }

  void _retry() {
    setState(() {
      _gamesFuture = _gameService.fetchGames(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Game>>(
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
                  const Text('Failed to load games.'),
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

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DetailsScreen.routeName,
                    arguments: game,
                  );
                },
                child: CustomHomeCard(game),
              );
            },
          );
        },
      ),
    );
  }
}
