import 'package:flutter/material.dart';
import 'package:myapp/CustomWidgets/custom_library_card.dart';
import 'package:myapp/Models/game.dart';
import 'package:myapp/Services/favorite_service.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = "/Library";

  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Game> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favorites = _favoriteService.getAllFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload favorites when screen becomes visible
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _favorites.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on a game to add it',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _favorites.length,
                itemBuilder: (context, index) =>
                    CustomLibraryCard(_favorites[index]),
              ),
      ),
    );
  }
}
