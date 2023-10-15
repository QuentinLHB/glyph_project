import 'package:flutter/material.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

class GlyphView extends StatefulWidget {
  final ComplexGlyph glyph;
  const GlyphView({Key? key, required this.glyph}) : super(key: key);

  @override
  State<GlyphView> createState() => _GlyphViewState();
}

class _GlyphViewState extends State<GlyphView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: widget.glyph.glyphs.map((g) => SvgGlyphWidget(svgString: g.svg)).toList(),
    );
  }
}
