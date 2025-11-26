import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/Models/dto/game_dto.dart';
import 'package:myapp/Models/game.dart';

class GameService {
  static const String _endpoint = 'https://www.freetogame.com/api/games';

  Future<List<Game>> fetchGames({int limit = 20}) async {
    final effectiveLimit = limit <= 0 ? 20 : limit;
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode != 200) {
      throw Exception('Failed to load games: HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Unexpected games payload');
    }

    final games = decoded
        .map((dynamic item) => Game.fromDto(GameDto.fromJson(item as Map<String, dynamic>)))
        .toList();

    if (games.length <= effectiveLimit) {
      return games;
    }

    return games.take(effectiveLimit).toList();
  }
}
