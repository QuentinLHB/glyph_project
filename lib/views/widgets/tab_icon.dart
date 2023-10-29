import 'package:flutter/material.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

import '../../models/glyph_type.dart';

class TabIcon extends StatelessWidget {
  final GlyphType glyphType;

  TabIcon({required this.glyphType});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: glyphType.description, // Message à afficher
      child: Container(
        width: 40,  // Ajustez selon vos besoins
        height: 50, // Ajustez selon vos besoins
        decoration: BoxDecoration(
          color: Colors.grey[200],  // Couleur d'arrière-plan du rectangle, ajustez selon vos besoins
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgGlyphWidget(svgString: glyphType.svg, size: 20),  // Taille du SVG à l'intérieur du rectangle
        ),
      ),
    );
  }

}
