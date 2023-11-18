import 'package:flutter/material.dart';
import 'package:glyph_project/views/pages/write_message.dart';

import '../../models/message.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // Ici, vous aurez une liste de messages à afficher.
  // Pour l'instant, elle est vide ou contient des données factices.
  List<Message> messages = []; // Remplacez par vos données réelles.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].sender), // Affichez les détails du message ici.
                  subtitle: Text(messages[index].timestamp.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'écriture de message.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WriteMessagePage()),
                );
              },
              child: Text("Écrire un nouveau message"),
            ),
          ),
        ],
      ),
    );
  }
}
