import 'glyph.dart';

class ComplexGlyph  {
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


}
