import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';
import 'package:glyph_project/views/widgets/glyph_keyboard_tile.dart';
import 'package:glyph_project/views/widgets/tab_icon.dart';

import '../widgets/selectable_glyph_tile.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<GlyphType> types = <GlyphType>[];
  List<Glyph> keyboardGlyphs = <Glyph>[];
  List<Glyph> mergeableGlyphs = <Glyph>[];

  @override
  void initState() {
    super.initState();
    types = MainController.instance.glyphTypes;
    if (types.isNotEmpty) {
      keyboardGlyphs =
          MainController.instance.getGlyphsForTypeId(types.first.getId);
    }
    loadMergeableGlyphs();
  }

  void loadMergeableGlyphs() async {
    mergeableGlyphs = await MainController.instance.getMergeableGlyphs();
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

  Widget _buildKeyboard(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Wrap(
            spacing: 7, // Espace horizontal entre les tiles
            runSpacing: 4, // Espace vertical entre les tiles
            children: keyboardGlyphs.map((glyph) {
              final key = GlobalKey();
              return LongPressDraggable<Glyph>(
                data: glyph,
                feedback: GlyphKeyBoardTile(
                  glyph: glyph,
                  size: 60,
                  onTap: () => writeGlyph(MainController.instance
                      .convertGlyphIntoComplexGlyph(glyph)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GlyphKeyBoardTile(
                    key:key,
                    glyph: glyph,
                    size: 60,
                    onTap: () => writeGlyph(MainController.instance
                        .convertGlyphIntoComplexGlyph(glyph)),
                    onLongPress: () => _showFloatingMenu(context, glyph, key),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showFloatingMenu(BuildContext context, Glyph currentGlyph, GlobalKey key) {
    final double buttonSize = 50;
    final double spacing = buttonSize * 0.10;
    final List<Glyph> selectedGlyphs = [];

    void handleSelection(Glyph glyph, bool isSelected) {
      setState(() {
        if (isSelected) {
          selectedGlyphs.add(glyph);
        } else {
          selectedGlyphs.remove(glyph);
        }
      });
    }

    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy - 200,
        position.dx + 60,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200.0, // Ajuster selon les besoins pour la liste de glyphes
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: spacing,
                    runSpacing: spacing,
                    children: mergeableGlyphs.map((glyph) {
                      return SelectableGlyphTile(
                        glyph: glyph,
                        size: buttonSize,
                        onSelected: (isSelected) => handleSelection(glyph, isSelected),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  child: Text('Valider'),
                  onPressed: () {
                    Navigator.pop(context); // Fermer le menu
                    selectedGlyphs.insert(0, currentGlyph);
                    writeGlyph(MainController.instance.mergeGlyphs(selectedGlyphs));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((_) {
      // Que faire après la fermeture du menu, si nécessaire
    });
  }



  void updateKeyboard(GlyphType type) {
    setState(() {
      keyboardGlyphs = MainController.instance.getGlyphsForTypeId(type.getId);
    });
  }

  void writeGlyph(ComplexGlyph complexGlyphToWrite) {
    print("write : ${complexGlyphToWrite.glyphs.first.label}. Amount of glyphs : ${complexGlyphToWrite.glyphs.length}");
  }
}
