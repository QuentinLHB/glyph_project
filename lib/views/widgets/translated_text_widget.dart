import 'package:flutter/material.dart';
import 'package:glyph_project/views/widgets/glyph_card.dart';
import 'package:glyph_project/views/widgets/glyph_view.dart';

import '../../controllers/main_controller.dart';
import '../../models/complex_glyph.dart';

class TranslatedTextWidget extends StatelessWidget {
  final String text;

  const TranslatedTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ComplexGlyph>? translatedGlyphs = MainController.instance.convertStringToGlyphs(text);

    if (translatedGlyphs == null) {
      return Text(text);
    } else {
      return Row(
        children: translatedGlyphs.map((glyph) => GlyphView(glyph: glyph)).toList(),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      );
    }
  }
}

