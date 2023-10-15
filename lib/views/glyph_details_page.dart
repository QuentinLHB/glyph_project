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
           buildLowerScreen(),
          ],
        ),
      ),
    );
  }

  Widget buildLowerScreen(){
    return Expanded(
      flex: 1,  // Prend 1/3 de la hauteur disponible
      child: FutureBuilder<List<ComplexGlyph>>(
        future: MainController.instance.getMergeableGlyphs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez un indicateur de chargement tant que les données ne sont pas chargées
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Gérez les erreurs ici
            return Center(child: Text('Erreur lors du chargement des données'));
          } else {
            // Les données sont chargées, vous pouvez les afficher
            List<ComplexGlyph> mergeableGlyphs = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0, // espace entre les cards en horizontal
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.6,// espace entre les cards en vertical
              ),
              itemCount: mergeableGlyphs.length,
              itemBuilder: (context, index) {
                return GlyphCard(glyph: mergeableGlyphs[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildComplexGlyph(ComplexGlyph complexGlyph) {
    return Stack(
      children: complexGlyph.svgs.map((svg) => SvgGlyphWidget(svgString: svg)).toList(),
    );
  }

}
