import 'package:flutter/material.dart';
import 'package:myapp/Models/game.dart';

class CustomLibraryCard extends StatelessWidget {
  final Game game;

  const CustomLibraryCard(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final imageWidget = game.usesNetworkImage
        ? Image.network(game.image, height: 80, fit: BoxFit.cover)
        : Image.asset(game.image, height: 80, fit: BoxFit.cover);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            imageWidget,
            const SizedBox(height: 8),
            Text(game.name, textAlign: TextAlign.center),
            Text("${game.price} TND"),
          ],
        ),
      ),
    );
  }
}
