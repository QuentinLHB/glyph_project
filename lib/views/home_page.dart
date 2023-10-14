import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/glyph_card.dart';
import 'package:glyph_project/views/svg_glyph.dart';

import '../models/glyph_type.dart';
import 'glyph_details_page.dart';
import 'glyph_type_button_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Dictionnaire"),
          backgroundColor: Colors.lightBlueAccent
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: MainController.instance.glyphTypes.length,
          itemBuilder: (BuildContext context, int index) {
            GlyphType glyphType = MainController.instance.glyphTypes[index];
            List<ComplexGlyph> glyphsForType = MainController.instance.getGlyphsForType(glyphType);

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
            physics: NeverScrollableScrollPhysics(), // pour empêcher le défilement à l'intérieur du GridView
            itemCount: glyphsForType.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
            return GlyphCard(glyph: glyphsForType[index], onClick: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GlyphDetailPage(glyph: glyphsForType[index]),
                  ),
              );
              });
            },
            )
            ,
            ]
            ,
            );
          },
        ),
      ),
    );
  }


}