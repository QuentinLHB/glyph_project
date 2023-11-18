import 'glyph.dart';

class ComplexGlyph {
  final List<Glyph> glyphs;

  ComplexGlyph({
    required this.glyphs,
  });

  String get translation {
    return glyphs.map((glyph) => glyph.translation ?? "").join(" ");
  }

  String get description {
    return glyphs.map((glyph) => glyph.description ?? "").join(" ");
  }

  List<String> get svgs => glyphs.map((glyph) => glyph.svg).toList();

  List<int> get ids => glyphs.map((glyph) => glyph.id).toList();

  Glyph get baseGlyph {
    if (glyphs.length > 0)
      return glyphs.first;
    else {
      return Glyph.empty();
    }
  }
}
