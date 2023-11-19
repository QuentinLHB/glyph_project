import 'package:flutter/material.dart';
import 'package:glyph_project/views/widgets/svg_complex_glyph_widget.dart';
import 'package:intl/intl.dart';

import '../../models/message.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Réduit le padding vertical
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.sender,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                  formatDate(message.timestamp),
                style: TextStyle(fontSize: 8),
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
          Wrap(
            spacing: 8.0, // Espace horizontal entre les glyphes
            runSpacing: 8.0, // Espace vertical entre les lignes
            children: message.glyphs.map((complexGlyph) {
              return SvgComplexGlyphWidget(complexGlyph: complexGlyph, size: 30);
            }).toList(),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(dateTime);
  }


}
