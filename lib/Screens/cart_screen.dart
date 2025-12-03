import 'package:flutter/material.dart';
import 'package:myapp/Models/game.dart';
import 'package:myapp/Services/cart_service.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/Cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<Map<String, dynamic>> _cartItems = [];
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await _cartService.getCartItems();
    final total = await _cartService.getTotalPrice();
    setState(() {
      _cartItems = items;
      _totalPrice = total;
    });
  }

  Future<void> _removeItem(Game game) async {
    await _cartService.removeFromCart(game);
    _loadCartItems();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from cart'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _updateQuantity(Game game, int newQuantity) async {
    await _cartService.updateQuantity(game, newQuantity);
    _loadCartItems();
  }

  Future<void> _clearCart() async {
    await _cartService.clearCart();
    _loadCartItems();
  }

  Widget _buildImage(Game game) {
    if (game.usesNetworkImage) {
      return Image.network(game.image, fit: BoxFit.cover);
    }
    return Image.asset(game.image, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Vider le panier'),
                    content: const Text('Voulez-vous vider votre panier?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _clearCart();
                        },
                        child: const Text('Confirmer'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep),
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Votre panier est vide',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      final game = item['game'] as Game;
                      final quantity = item['quantity'] as int;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: _buildImage(game),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${game.price} TND',
                                      style: const TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Quantity controls
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => _updateQuantity(
                                            game,
                                            quantity - 1,
                                          ),
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          iconSize: 24,
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _updateQuantity(
                                            game,
                                            quantity + 1,
                                          ),
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          iconSize: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Delete button
                              IconButton(
                                onPressed: () => _removeItem(game),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total and checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '$_totalPrice TND',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Commande validée!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Commander'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
