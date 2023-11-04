import 'package:flutter/material.dart';
import 'package:glyph_project/views/widgets/svg_glyph.dart';

import '../../models/glyph.dart';

class SelectableGlyphTile extends StatefulWidget {
  final Glyph glyph;
  final double size;
  final Function(bool isSelected)? onSelected;

  const SelectableGlyphTile({
    Key? key,
    required this.glyph,
    required this.size,
    this.onSelected,
  }) : super(key: key);

  @override
  _SelectableGlyphTileState createState() => _SelectableGlyphTileState();
}

class _SelectableGlyphTileState extends State<SelectableGlyphTile> {
  bool isSelected = false;

  void _toggleSelected() {
    setState(() {
      isSelected = !isSelected;
    });
    widget.onSelected!(isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleSelected,
      child: Material(
        elevation: isSelected ? 5.0 : 2.0, // Ajoute de l'élévation si la tile est sélectionnée
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.grey[200], // La couleur change si la tile est sélectionnée
            border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null, // Ajoute un contour si la tile est sélectionnée
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgGlyphWidget(svgString: widget.glyph.svg, size: widget.size * 0.6),
          ),
        ),
      ),
    );
  }}

