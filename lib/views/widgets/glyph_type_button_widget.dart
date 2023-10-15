import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/glyph_type.dart';

class GlyphTypeWidget extends StatelessWidget {
  final GlyphType glyphType;

  GlyphTypeWidget({required this.glyphType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      // Pour donner un peu d'espacement autour du widget
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      // Ajustez ces valeurs pour obtenir la forme souhaitée
      decoration: BoxDecoration(
        color: Color(0xFFBFE4FF),
          borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child:
          Text("test"),
        // SvgPicture.string(
        //   glyphType.svg,
        //   fit: BoxFit.contain,
        //   height: 40, // Ajustez selon le rendu souhaité
        //   width: 60, // Ajustez selon le rendu souhaité
        // ),
      ),
    );
  }
}
