import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glyph_project/models/complex_glyph.dart';

import '../models/glyph.dart';

class GlyphCard extends StatelessWidget {
  final ComplexGlyph glyph;
  final VoidCallback? onClick;


  GlyphCard({required this.glyph, this.onClick});

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick?.call(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: glyph.glyphs.map((g) => SvgGlyphWidget(svgString: g.svg)).toList(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  glyph.translation, // La translation est déjà construite grâce au getter dans ComplexGlyph.
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
