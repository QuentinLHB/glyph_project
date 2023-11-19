import 'complex_glyph.dart';

class Message {
  String sender;
  DateTime timestamp;

  /// First layer : List of complex Glyph. Second Layer : List of Glyphs inside the Complex Glyph.
  List<List<int>> glyphIds; // Liste de listes d'ID de glyphs
  List<ComplexGlyph> glyphs = [];

  Message({required this.sender, required this.timestamp, required this.glyphIds});

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'glyphs': glyphIds,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
      glyphIds: (json['glyphs'] as List<dynamic>)
          .map((e) => List<int>.from(e as List))
          .toList(),
    );
  }
}
