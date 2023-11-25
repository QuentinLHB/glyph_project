import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/message_controller.dart';
import 'package:glyph_project/models/conversation.dart';
import 'package:glyph_project/views/pages/write_message.dart';
import 'package:glyph_project/views/widgets/message_tile_widget.dart';

import '../../models/message.dart';

enum MenuOptions { changeName, deleteContent, deleteConversation }

class ConversationPage extends StatefulWidget {
  Conversation conversation;

  ConversationPage({required this.conversation});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  // Ici, vous aurez une liste de messages à afficher.
  // Pour l'instant, elle est vide ou contient des données factices.

  bool forceLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversation"),
        actions: <Widget>[
          PopupMenuButton<MenuOptions>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return MenuOptions.values.map((MenuOptions option) {
                return PopupMenuItem<MenuOptions>(
                  value: option,
                  child: Text(_getDisplayText(option)),
                );
              }).toList();
            },
            icon: Icon(Icons.settings), // Icône de rouage
          ),
        ],
      ),
      body: FutureBuilder<Conversation?>(
          future: MessageController.instance
              .loadConversationMessage(widget.conversation),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            print(forceLoading);
            if (forceLoading ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError ||
                (snapshot.hasData && snapshot.data == null)) {
              return Text("Erreur lors de la récupération des messages");
            } else {
              Conversation conversation = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: conversation.messages.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                            message: conversation.messages[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await goToWriteMessage();
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

  Future<void> goToWriteMessage() async {
    // Lorsque vous naviguez vers WriteMessagePage
    var returnedMessage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WriteMessagePage()),
    );

    if (returnedMessage != null) {
      if (returnedMessage == true) {
        setState(() {
          forceLoading = true;
        });
        bool success = await MessageController.instance
            .validateMessage(widget.conversation, "Quentin"); //todo username
        if (success) {
          setState(() {
            forceLoading = false;
          });
        } else {
          // todo toast
        }
      }
    }
  }

  String _getDisplayText(MenuOptions option) {
    switch (option) {
      case MenuOptions.changeName:
        return 'Changer de nom';
      case MenuOptions.deleteContent:
        return 'Supprimer le contenu';
      case MenuOptions.deleteConversation:
        return 'Supprimer la conversation';
      default:
        return '';
    }
  }

  void _handleMenuSelection(MenuOptions value) {
    switch (value) {
      case MenuOptions.changeName:
      // Logique pour changer de nom
        break;
      case MenuOptions.deleteContent:
        _confirmDeleteContent();
        break;
      case MenuOptions.deleteConversation:
      // Logique pour supprimer la conversation
        break;
      default:
        print('Action non reconnue');
    }
  }

  void _confirmDeleteContent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer tout le contenu de cette conversation?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            ElevatedButton(
              child: Text('Supprimer'),
              onPressed: () {
                // Ajoutez ici la logique pour supprimer le contenu
                delete();

                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> delete() async{
    bool success = await MessageController.instance.clearConversation(widget.conversation);
    if(success) setState(() {});

  }

}
