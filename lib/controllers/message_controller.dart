import 'package:glyph_project/models/complex_glyph.dart';

class MessageController {
  static final MessageController _instance = MessageController._internal();

  MessageController._internal();

  static MessageController get instance => _instance;

  final List<ComplexGlyph> _messageBeingWritten = <ComplexGlyph>[];

  List<ComplexGlyph> get messageBeingWritten => _messageBeingWritten;

  void addGlyph(ComplexGlyph newGlyph) {
    messageBeingWritten.add(newGlyph);
  }

  void modifyGlyph(ComplexGlyph glyphToModify, ComplexGlyph newGlyph) {
    int index = messageBeingWritten
        .indexWhere((item) => identical(item, glyphToModify));
    messageBeingWritten.removeAt(index);
    messageBeingWritten.insert(index, newGlyph);
  }

  void deleteGlyph(ComplexGlyph glyphToDelete) {
    messageBeingWritten.removeWhere((item) => identical(item, glyphToDelete));
  }

  void clearMessage() {
    messageBeingWritten.clear();
  }

}
