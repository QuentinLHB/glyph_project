import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/glyph_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/widgets/glyph_card.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';
import 'package:glyph_project/views/widgets/translated_text_widget.dart';

import '../../models/glyph_type.dart';
import 'glyph_details_page.dart';
import '../widgets/glyph_type_button_widget.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TranslatedTextWidget("gline", size: 50, textAlign: TextAlign.start,)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: GlyphController.instance.glyphTypes.length,
          itemBuilder: (BuildContext context, int index) {
            GlyphType glyphType = GlyphController.instance.glyphTypes[index];
            List<ComplexGlyph> glyphsForType =
                GlyphController.instance.getGlyphsForType(glyphType);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre du type
                Text(
                  glyphType.label,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                // Grille de glyphs pour ce type
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // pour empêcher le défilement à l'intérieur du GridView
                  itemCount: glyphsForType.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    return GlyphCard(
                        glyph: glyphsForType[index],
                        onClick: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  GlyphDetailPage(glyph: glyphsForType[index]),
                            ),
                          );
                        });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
