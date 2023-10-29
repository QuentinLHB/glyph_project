import 'package:flutter/material.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

import '../../models/glyph_type.dart';

class GlyphKeyBoardTile extends StatelessWidget {
  final Glyph glyph;

  GlyphKeyBoardTile({required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: glyph.description, // Message à afficher
      child: Container(
        width: 50,  // Ajustez selon vos besoins
        height: 60, // Ajustez selon vos besoins
        decoration: BoxDecoration(
          color: Colors.grey[200],  // Couleur d'arrière-plan du rectangle, ajustez selon vos besoins
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgGlyphWidget(svgString: glyph.svg, size: 20),  // Taille du SVG à l'intérieur du rectangle
        ),
      ),
    );
  }

}
