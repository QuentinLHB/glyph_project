import 'package:flutter/material.dart';
import 'package:glyph_project/views/widgets/svg_complex_glyph_widget.dart';

import '../../models/message.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message.sender,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                message.timestamp.toIso8601String(),
                style: TextStyle(fontSize: 12),
              ),
              PopupMenuButton<String>(
                onSelected: (String result) {
                  // Gérez votre action ici
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Action 1',
                    child: Text('Action 1'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Action 2',
                    child: Text('Action 2'),
                  ),
                  // Ajoutez d'autres éléments si nécessaire
                ],
              ),
            ],
          ),
          ...message.glyphs.map((complexGlyph) {
            return SvgComplexGlyphWidget(complexGlyph: complexGlyph, size: 16,);
          }).toList(),
        ],
      ),
    );
  }
}
