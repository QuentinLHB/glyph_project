import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';

import '../models/complex_glyph.dart';
import '../models/glyph.dart';
import 'glyph_card.dart';

class GlyphDetailPage extends StatelessWidget {
  final ComplexGlyph glyph;

  GlyphDetailPage({required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la Glyph"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Partie haute de l'écran
            Expanded(
              flex: 2,  // Prend les 2/3 de la hauteur disponible
              child: Row(
                children: [
                  // Partie gauche : GlyphCard
                  Expanded(
                    child: GlyphCard(glyph: glyph),
                  ),
                  // Partie droite : Description et Traduction
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(glyph.description),
                        SizedBox(height: 20),
                        Text(
                          "Traduction:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(glyph.translation ?? "Pas de traduction disponible"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Partie basse de l'écran pour afficher d'autres éléments ultérieurement
            Expanded(
              flex: 1,  // Prend 1/3 de la hauteur disponible
              child: Center(
                child: buildComplexGlyph(MainController.instance.fuseGlyphs([...glyph.glyphs, MainController.instance.getGlyphsForTypeId(3)[1].glyphs[0], MainController.instance.getGlyphsForTypeId(3)[0].glyphs[0]]
                ))
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildComplexGlyph(ComplexGlyph complexGlyph) {
    return Stack(
      children: complexGlyph.svgs.map((svg) => SvgGlyphWidget(svgString: svg)).toList(),
    );
  }

}
