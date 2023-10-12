import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/glyph.dart';

class GlyphCard extends StatelessWidget {
  final Glyph glyph;

  GlyphCard({required this.glyph});

  Widget build(BuildContext context) {
    return Card(
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
              child: SvgGlyphWidget(svgString: glyph.svg),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.all(7.0),
              child: Text(
                glyph.translation ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
