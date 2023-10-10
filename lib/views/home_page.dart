import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/views/glyph_card.dart';
import 'package:glyph_project/views/svg_glyph.dart';


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
      body: FutureBuilder<List<Glyph>>(
        future: MainController().getAllGlyphs(), // Assurez-vous d'avoir une méthode qui renvoie Future<List<Glyph>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Aucune donnée disponible');
          } else {
            List<Glyph> myGlyphs = snapshot.data!;

            return Center(
              child: Wrap(
                spacing: 8.0, // l'espace entre les widgets horizontalement
                runSpacing: 4.0, // l'espace entre les widgets verticalement
                children: myGlyphs.map((glyph) => GlyphCard(glyph: glyph)).toList(),
              ),
            );
          }
        },
      ),
    );
  }

}