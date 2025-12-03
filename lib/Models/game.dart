import 'package:hive/hive.dart';
import 'package:myapp/Models/dto/game_dto.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final int price;

  Game({required this.image, required this.name, required this.price});

  factory Game.fromDto(GameDto dto) =>
      Game(image: dto.image, name: dto.name, price: dto.price);

  bool get usesNetworkImage => image.startsWith('http');

  // For SQLite
  Map<String, dynamic> toMap() {
    return {'name': name, 'image': image, 'price': price};
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      name: map['name'] as String,
      image: map['image'] as String,
      price: map['price'] as int,
    );
  }
}
