import 'package:flutter/material.dart';
import 'package:myapp/Models/game.dart';

class CustomHomeCard extends StatelessWidget {
  final Game game;

  const CustomHomeCard(this.game, {super.key});

  Widget _buildImage() {
    if (game.usesNetworkImage) {
      return Image.network(game.image, height: 100, width: 120, fit: BoxFit.cover);
    }
    return Image.asset(game.image, height: 100, width: 120, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImage(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 120, child: Text(game.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  Text('${game.price} TND', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
