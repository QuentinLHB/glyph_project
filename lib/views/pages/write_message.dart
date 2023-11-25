import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/glyph_controller.dart';
import 'package:glyph_project/controllers/message_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';
import 'package:glyph_project/utils/constants.dart';
import 'package:glyph_project/views/widgets/glyph_keyboard_tile.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';
import 'package:glyph_project/views/widgets/tab_icon.dart';

import '../widgets/selectable_glyph_tile.dart';
import '../widgets/svg_complex_glyph_widget.dart';

class WriteMessagePage extends StatefulWidget {
  const WriteMessagePage({Key? key}) : super(key: key);

  @override
  State<WriteMessagePage> createState() => _WriteMessagePageState();
}

class _WriteMessagePageState extends State<WriteMessagePage> {
  List<GlyphType> types = <GlyphType>[];
  List<Glyph> keyboardGlyphs = <Glyph>[];
  List<Glyph> mergeableGlyphs = <Glyph>[];

  @override
  void initState() {
    super.initState();
    types = GlyphController.instance.glyphTypes;
    if (types.isNotEmpty) {
      keyboardGlyphs =
          GlyphController.instance.getGlyphsForTypeId(types.first.getId);
    }
    loadMergeableGlyphs();
  }

  void loadMergeableGlyphs() async {
    mergeableGlyphs = await GlyphController.instance.getMergeableGlyphs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messagerie"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessageArea(context),
          Center(child:ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            onPressed: sendMessage,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5, // Largeur souhaitée en points
              child: Center(child: Text("Envoyer")),
            ),
          )
          ),
          Expanded(child: _buildGlyphKeyboard(context)),
        ],
      ),
    );
  }

  void sendMessage(){
    Navigator.pop(context, true);

  }

  late StateSetter messageAreaSetState;


  Widget _buildMessageArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.4,

      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          messageAreaSetState = setState;
          return SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: MessageController.instance.messageBeingWritten.map((
                  complexGlyph) {
                return GestureDetector(
                  onLongPressStart: (LongPressStartDetails details) {
                    _showContextMenu(details.globalPosition, complexGlyph);
                  },
                  child: Container(
                    // Vous pouvez ajuster la taille et le style comme vous le souhaitez
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      // Ajoutez les décorations que vous souhaitez ici
                    ),
                    child: SvgComplexGlyphWidget(complexGlyph: complexGlyph, size: 36), // Adaptez selon votre widget de glyphe
                  ),
                );
              }).toList(),
            ),

          );
        },
      ),
    );
  }

  void _showContextMenu(Offset tapPosition, ComplexGlyph selectedGlyph) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1,
        tapPosition.dy + 1,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 'edit',
          child: Text('Modifier'),
          // Pas besoin de onTap si on a un onTapDown sur le GestureDetector
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Supprimer'),
          // Pas besoin de onTap si on a un onTapDown sur le GestureDetector
        ),
      ],
    ).then((value) {
      // Vous pouvez traiter la valeur retournée ici, si nécessaire
      if (value == 'edit') {
        edit(selectedGlyph);
      } else if (value == 'delete') {
        delete(selectedGlyph);
      }
    });
  }


  Widget _buildGlyphKeyboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThemeTabs(context),
        _buildOptionsRow(context),
        Expanded(child: _buildKeyboard(context)),
      ],
    );
  }

  Widget _buildThemeTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
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
                padding: const EdgeInsets.only(right: 7.0),
                // Réduisez le padding pour réduire l'espace entre les éléments
                child: TabIcon(
                  glyphType: type,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isTranslationVisible = false;

  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Enveloppez la Checkbox et le Texte dans un InkWell
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _toggleTranslation();},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _isTranslationVisible,
                onChanged: (bool? value) {
                  _toggleTranslation();
                },
              ),
              Text('Traductions'), // Texte à côté de la checkbox
            ],
          ),
        ),

        // Bouton pour supprimer le message
        ElevatedButton(
          onPressed: () {
            setState(() {
              MessageController.instance.clearMessage();
            });
          },
          child: Text('Suppr. le message'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ],
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
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GlyphKeyBoardTile(
                  key: key,
                  glyph: glyph,
                  size: 60,
                  onTap: () =>
                      write(GlyphController.instance
                          .convertGlyphIntoComplexGlyph(glyph)),
                  onLongPress: () => _showFloatingMenu(context, glyph, key),
                  showTranslation: _isTranslationVisible,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showFloatingMenu(BuildContext context, Glyph currentGlyph,
      GlobalKey key) {
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

    final RenderBox renderBox = key.currentContext!
        .findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      color: Colors.white,
      surfaceTintColor: Colors.white,
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
                        onSelected: (isSelected) =>
                            handleSelection(glyph, isSelected),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  child: Text('Valider'),
                  onPressed: () {
                    selectedGlyphs.insert(0, currentGlyph);
                    write(GlyphController.instance.mergeGlyphs(selectedGlyphs));
                    Navigator.pop(context); // Fermer le menu
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor, // Texte du bouton en blanc
                  ),
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
      keyboardGlyphs = GlyphController.instance.getGlyphsForTypeId(type.getId);
    });
  }

  void write(ComplexGlyph complexGlyphToWrite) {
    // print("write : ${complexGlyphToWrite.glyphs.first
    //     .label}. Amount of glyphs : ${complexGlyphToWrite.glyphs.length}");
    messageAreaSetState(() =>
        MessageController.instance.addGlyph(complexGlyphToWrite));
  }

  void delete(ComplexGlyph glyphToDelete) {
    messageAreaSetState(() =>
        MessageController.instance.deleteGlyph(glyphToDelete));
  }

  void edit(ComplexGlyph glyphToEdit) {

  }

  void _toggleTranslation() {
    setState(() {
      _isTranslationVisible = !_isTranslationVisible;
      // Ajoutez ici votre logique pour gérer l'affichage de la traduction
    });
  }

  // final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

}
