import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/message_controller.dart';
import 'package:glyph_project/models/conversation.dart';
import 'package:glyph_project/views/pages/write_message.dart';
import 'package:glyph_project/views/widgets/message_tile_widget.dart';

import '../../models/message.dart';

class ConversationPage extends StatefulWidget {
  Conversation conversation;

  ConversationPage({required this.conversation});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // Ici, vous aurez une liste de messages à afficher.
  // Pour l'instant, elle est vide ou contient des données factices.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation"),
      ),
      body: FutureBuilder<Conversation?>(
          future: MessageController.instance
              .loadConversationMessage(widget.conversation),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || (snapshot.hasData && snapshot.data == null)) {
              return Text("Erreur lors de la récupération des messages");
            } else {
              Conversation conversation = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversation.messages.length,
                      itemBuilder: (context, index) {
                        return MessageTile(message: conversation.messages[index]);
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
                          MaterialPageRoute(
                              builder: (context) => const WriteMessagePage()),
                        );
                      },
                      child: Text("Écrire un nouveau message"),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
