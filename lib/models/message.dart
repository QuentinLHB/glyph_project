class Message {
  String sender;
  DateTime timestamp;
  List<List<int>> glyphs; // Liste de listes d'ID de glyphs

  Message({required this.sender, required this.timestamp, required this.glyphs});

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'glyphs': glyphs,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
      glyphs: (json['glyphs'] as List<dynamic>)
          .map((e) => List<int>.from(e as List))
          .toList(),
    );
  }
}
