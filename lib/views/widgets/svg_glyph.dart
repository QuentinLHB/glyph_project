import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgGlyphWidget extends StatelessWidget {
  String svgString;
  final double? size;

  SvgGlyphWidget({required this.svgString, this.size});

  @override
  Widget build(BuildContext context) {
    // String correctedSvg = svgString;
    if(svgString == "") svgString = "<svg></svg>";
    return SvgPicture.string(
      svgString,
      width: size ?? 100,  // Largeur en unités logiques
      height: size ?? 100, // Hauteur en unités logiques
      fit: BoxFit.contain,
    );
  }
}
