import 'package:myapp/Models/dto/game_dto.dart';

class Game {
  final String name;
  final String image;
  final int price;

  const Game({
    required this.image,
    required this.name,
    required this.price,
  });

  factory Game.fromDto(GameDto dto) => Game(
        image: dto.image,
        name: dto.name,
        price: dto.price,
      );

  bool get usesNetworkImage => image.startsWith('http');
}
