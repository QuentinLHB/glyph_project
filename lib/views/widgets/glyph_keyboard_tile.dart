import 'package:flutter/material.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

import '../../models/glyph_type.dart';
class GlyphKeyBoardTile extends StatelessWidget {
  final Glyph glyph;
  final double size;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showTranslation;

  GlyphKeyBoardTile({
    Key? key,
    required this.glyph,
    required this.size,
    required this.onTap,
    this.onLongPress,
    this.showTranslation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(8), // Appliquez le borderRadius ici
        color: Colors.transparent, // Assurez-vous que Material n'ajoute pas sa propre couleur de fond
        child: Ink( // Utilisez Ink pour appliquer une couleur sur un Material avec un borderRadius
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: size,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Utilisez l'espace minimum nécessaire pour le contenu
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgGlyphWidget(svgString: glyph.svg, size: size * 0.6),
                  ),
                ),
                if (showTranslation) // Affiche la traduction seulement si showTranslation est true
                  Padding(
                    padding: const EdgeInsets.only(top: 4), // Un peu d'espace entre le SVG et la traduction
                    child: Text(
                      glyph.translation ?? "-",
                      style: TextStyle(
                        fontSize: size * 0.15, // La taille du texte sera proportionnelle à la taille du tile
                        // Ajoutez ici d'autres styles si nécessaire
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
