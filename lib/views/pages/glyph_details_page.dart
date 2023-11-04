import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/widgets/translated_text_widget.dart';

import '../../models/complex_glyph.dart';
import '../widgets/glyph_card.dart';
import '../widgets/svg_glyph.dart';

class GlyphDetailPage extends StatefulWidget {
  final ComplexGlyph glyph;

  GlyphDetailPage({required this.glyph});

  @override
  _GlyphDetailPageState createState() => _GlyphDetailPageState();
}

class _GlyphDetailPageState extends State<GlyphDetailPage>  {
  late ComplexGlyph currentGlyph;

  List<Glyph> mergedGlyphs = [];
  late StateSetter stateSetter;

  @override
  void initState() {
    super.initState();
    currentGlyph = widget.glyph;
    mergedGlyphs = List.from(widget.glyph.glyphs);
  }

  void mergeGlyph(ComplexGlyph newGlyph) {
    stateSetter(() {
      if (mergedGlyphs.any((glyph) => glyph.id == newGlyph.glyphs[0].id)) {
        mergedGlyphs.removeWhere((glyph) => glyph.id == newGlyph.glyphs[0].id);
      } else {
        mergedGlyphs.addAll(newGlyph.glyphs);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedTextWidget("mot ${widget.glyph.baseGlyph.label}"),
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
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState){
                      stateSetter = setState;
                      return Expanded(
                        child: GlyphCard(glyph: ComplexGlyph(glyphs: mergedGlyphs)),
                      );
                    },

                  ),


                  // Partie droite : Description et Traduction
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(currentGlyph.description),
                        SizedBox(height: 20),
                        const Text(
                          "Traduction:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(currentGlyph.translation ?? "Pas de traduction disponible"),
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
        future: GlyphController.instance.getMergeableComplexGlyphs(),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0, // espace entre les cards en horizontal
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.6,// espace entre les cards en vertical
              ),
              itemCount: mergeableGlyphs.length,
              itemBuilder: (context, index) {
                return GlyphCard(glyph: mergeableGlyphs[index], onClick: () => mergeGlyph(mergeableGlyphs[index]),);
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


