
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgGlyphWidget extends StatelessWidget {
  final String svgString;

  SvgGlyphWidget({required this.svgString});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svgString,
      width: 100,  // Largeur en unités logiques
      height: 100, // Hauteur en unités logiques
      fit: BoxFit.contain,
    );
  }
}