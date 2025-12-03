import 'package:flutter/material.dart';
import 'package:myapp/Models/game.dart';
import 'package:myapp/Services/favorite_service.dart';
import 'package:myapp/Services/cart_service.dart';

class DetailsScreen extends StatefulWidget {
  //routes
  static const String routeName = "/Details";
  //var
  var counter = 3000;
  late Game currentGame;
  DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  final CartService _cartService = CartService();
  bool _isFavorite = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.currentGame = ModalRoute.of(context)!.settings.arguments as Game;
    _isFavorite = _favoriteService.isFavorite(widget.currentGame);
  }

  void _toggleFavorite() async {
    final result = await _favoriteService.toggleFavorite(widget.currentGame);
    setState(() {
      _isFavorite = result;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCart() async {
    await _cartService.addToCart(widget.currentGame);
    setState(() {
      widget.counter--;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildImage(Game game) {
    if (game.usesNetworkImage) {
      return Image.network(game.image, fit: BoxFit.cover);
    }
    return Image.asset(game.image, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.currentGame;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 25,
          children: [
            //1
            _buildImage(game),
            //2
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            ),
            //3
            Column(
              children: [
                Text(
                  "${game.price} TND",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Nombre d'exemplaire disponible : ${widget.counter}"),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _addToCart,
              label: const Text("Acheter"),
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
      ),
    );
  }
}
