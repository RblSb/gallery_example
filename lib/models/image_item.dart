import 'package:flutter/foundation.dart';

class ImageItemModel extends ChangeNotifier {
  final String userName;
  final String description;
  final String thumbSrc;
  final String regularSrc;

  ImageItemModel({
    required this.userName,
    required this.description,
    required this.thumbSrc,
    required this.regularSrc,
  });

  factory ImageItemModel.fromJson(Map<String, dynamic> json) {
    return ImageItemModel(
      userName: json['user']['name'] ?? 'Unknown author',
      description: _capitalize(json['description'] ?? ''),
      thumbSrc: json['urls']['small'],
      regularSrc: json['urls']['regular'],
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
