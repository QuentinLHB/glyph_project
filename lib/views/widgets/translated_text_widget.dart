import 'package:flutter/material.dart';

import '../../controllers/glyph_controller.dart';
import '../../models/complex_glyph.dart';
import 'glyph_view.dart';

class TranslatedTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? size;

  // ... tout autre paramètre que vous voulez personnaliser

  const TranslatedTextWidget(
      this.text, {
        Key? key,
        this.style,
        this.textAlign = TextAlign.center,
        this.textDirection,
        this.size
        // ... tout autre paramètre que vous voulez personnaliser
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ComplexGlyph>? translatedGlyphs = GlyphController.instance.convertStringToGlyphs(text);

    if (translatedGlyphs == null) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        // ... tout autre paramètre que vous avez inclus
      );
    } else {
      return Row(
        mainAxisAlignment: textAlignToMainAxisAlignment(textAlign),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: translatedGlyphs.map((glyph) => GlyphView(glyph: glyph, size: size,)).toList(),
      );
    }
  }

  MainAxisAlignment textAlignToMainAxisAlignment(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.left:
        return MainAxisAlignment.start;
      case TextAlign.right:
        return MainAxisAlignment.end;
      case TextAlign.center:
        return MainAxisAlignment.center;
      case TextAlign.justify:
      case TextAlign.start:
      case TextAlign.end:
        return MainAxisAlignment.start;  // À ajuster selon vos besoins
      default:
        return MainAxisAlignment.start;
    }
  }

}
