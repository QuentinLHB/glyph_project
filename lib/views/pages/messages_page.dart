import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';
import 'package:glyph_project/views/widgets/glyph_keyboard_tile.dart';
import 'package:glyph_project/views/widgets/tab_icon.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<GlyphType> types = <GlyphType>[];
  List<Glyph> keyboardGlyphs = <Glyph>[];

  @override
  void initState() {
    types = MainController.instance.glyphTypes;
    if (types.isNotEmpty) {
      keyboardGlyphs = MainController.instance.getGlyphsForTypeId(types.first.getId);
    }
  }

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
      height:
          MediaQuery.of(context).size.height * 0.3, // 30% of the screen height
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThemeTabs(context),
        Expanded(child: _buildKeyboard(context)),
      ],
    );
  }

  Widget _buildThemeTabs(BuildContext context) {
    // Pour l'instant, je vais simplement simuler une liste de thèmes. Remplacez ceci par le vrai appel au contrôleur.

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // Pour aligner les éléments à gauche
        children: types.map((type) {
          return InkWell(
            onTap: () {
              updateKeyboard(type);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              // Réduisez le padding pour réduire l'espace entre les éléments
              child: TabIcon(
                glyphType: type,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds a keyboard based on the current theme
  Widget _buildKeyboard(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Wrap(
            spacing: 7, // Espace horizontal entre les tiles
            runSpacing: 4, // Espace vertical entre les tiles
            children: keyboardGlyphs.map((glyph) {
              return InkWell(
                onTap: () {
                  // Action lorsqu'un glyphe est pressé
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GlyphKeyBoardTile(glyph: glyph, size: 60),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void updateKeyboard(GlyphType type) {
    setState(() {
      keyboardGlyphs = MainController.instance.getGlyphsForTypeId(type.getId);
    });
  }
}
