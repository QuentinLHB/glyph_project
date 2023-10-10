import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/glyph.dart';

class GlyphCard extends StatelessWidget {
  final Glyph glyph;

  GlyphCard({required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SvgGlyphWidget(svgString: glyph.svg),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              glyph.translation?? "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SvgGlyphWidget extends StatelessWidget {
  final String svgString;

  SvgGlyphWidget({required this.svgString});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svgString,
      width: 100,  // Largeur en unités logiques
      height: 100, // Hauteur en unités logiques
      fit: BoxFit.contain,
    );
  }
}
