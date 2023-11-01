import 'package:flutter/material.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

import '../../models/glyph_type.dart';

class GlyphKeyBoardTile extends StatelessWidget {
  final Glyph glyph;
  final double size;

  GlyphKeyBoardTile({required this.glyph, required this.size});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: glyph.description, // Message à afficher
      child: Container(
        width: size,  // Ajustez selon vos besoins
        height: size, // Ajustez selon vos besoins
        decoration: BoxDecoration(
          color: Colors.grey[200],  // Couleur d'arrière-plan du rectangle, ajustez selon vos besoins
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgGlyphWidget(svgString: glyph.svg, size: size*0.6),  // Taille du SVG à l'intérieur du rectangle
        ),
      ),
    );
  }

}
