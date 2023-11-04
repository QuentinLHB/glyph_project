import 'package:flutter/material.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

class SvgComplexGlyphWidget extends StatelessWidget {
  final  ComplexGlyph complexGlyph;
  final double? size;
  const SvgComplexGlyphWidget({Key? key, required this.complexGlyph, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: complexGlyph.svgs.map((svg) => SvgGlyphWidget(svgString: svg, size: size,)).toList(),
    );
  }
}
