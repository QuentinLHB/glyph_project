import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';
import 'package:glyph_project/views/widgets/glyph_keyboard_tile.dart';
import 'package:glyph_project/views/widgets/tab_icon.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messagerie"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildMessageArea(context),
          Expanded(child: _buildGlyphKeyboard(context)),
        ],
      ),
    );
  }

  Widget _buildMessageArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.3, // 30% of the screen height
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SingleChildScrollView(
        child: Text(
          "Message en train d'être écrit",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildGlyphKeyboard(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        _buildThemeTabs(context),
        Expanded(child: _buildGlyphGrid(context)),
      ],
    );
  }

  Widget _buildThemeTabs(BuildContext context) {
    // Pour l'instant, je vais simplement simuler une liste de thèmes. Remplacez ceci par le vrai appel au contrôleur.
    List<GlyphType> themes = MainController.instance.glyphTypes;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,  // Pour aligner les éléments à gauche
        children: themes.map((theme) {
          return InkWell(
            onTap: () {
              // Lorsqu'un thème est sélectionné, appelez le contrôleur pour mettre à jour la liste des glyphes.
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 2.0),  // Réduisez le padding pour réduire l'espace entre les éléments
              child: TabIcon(glyphType: theme,),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGlyphGrid(BuildContext context) {
    // Pour l'instant, je vais simplement simuler une liste de glyphes. Remplacez ceci par le vrai appel au contrôleur.
    List<Glyph> glyphs = MainController.instance.glyphs;

    return ListView(
      children: [
        Wrap(
          spacing: 4, // Espace horizontal entre les tiles
          runSpacing: 4, // Espace vertical entre les tiles
          children: glyphs.map((glyph) {
            return InkWell(
              onTap: () {
                // Action lorsqu'un glyphe est pressé
              },
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: GlyphKeyBoardTile(glyph: glyph),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

}
