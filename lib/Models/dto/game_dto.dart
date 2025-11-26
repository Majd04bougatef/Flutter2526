import 'package:flutter/foundation.dart';

@immutable
class GameDto {
  final String name;
  final String image;
  final int price;

  const GameDto({
    required this.name,
    required this.image,
    required this.price,
  });

  factory GameDto.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final parsedPrice = _parsePrice(rawPrice);

    return GameDto(
      name: json['title']?.toString() ?? '',
      image: json['thumbnail']?.toString() ?? '',
      price: parsedPrice,
    );
  }

  static int _parsePrice(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.floor();
    }

    final normalized = value.toString().trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'free') {
      return 0;
    }

    final withoutCurrency = normalized.replaceAll(RegExp(r'[^0-9]'), '');
    if (withoutCurrency.isEmpty) {
      return 0;
    }

    return int.tryParse(withoutCurrency) ?? 0;
  }
}
