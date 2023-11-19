import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/conversation.dart';
import '../models/message.dart';

class MessageController {
  /// Token used to retrieve messages from URL
  String? _token;

  static final MessageController _instance = MessageController._internal();

  MessageController._internal();

  /// Initialises the token
  Future<void> initToken() async {
    _token ??= await getToken();
  }

  static MessageController get instance => _instance;

  /// Message written by the user
  final List<ComplexGlyph> _messageBeingWritten = <ComplexGlyph>[];

  List<ComplexGlyph> get messageBeingWritten => _messageBeingWritten;

  /// Adds a glyph to the current message
  void addGlyph(ComplexGlyph newGlyph) {
    messageBeingWritten.add(newGlyph);
  }

  /// Replaces a glyph with another in the current message.
  void replaceGlyph(ComplexGlyph glyphToModify, ComplexGlyph newGlyph) {
    int index = messageBeingWritten
        .indexWhere((item) => identical(item, glyphToModify));
    messageBeingWritten.removeAt(index);
    messageBeingWritten.insert(index, newGlyph);
  }

  /// Deletes a glyph from the current message.
  void deleteGlyph(ComplexGlyph glyphToDelete) {
    messageBeingWritten.removeWhere((item) => identical(item, glyphToDelete));
  }

  /// Deletes the current message.
  void clearMessage() {
    messageBeingWritten.clear();
  }

  // region SEND_MESAGE

  /// Retrieves messages history of a conversation.
  /// Returns a Conversation object filled with Message objects.
  Future<Conversation?> loadConversationMessage(
      Conversation conversation) async {
    try {
      final response = await http.get(
        Uri.parse(conversation.url),
        headers: {
          'Authorization': 'token $_token',
          'Accept': 'application/vnd.github.v3.raw',
        },
      );
      if (response.statusCode == 200) {
        // Étape 2: Décoder le contenu JSON
        var data = jsonDecode(response.body);

        String? title = data['title'];
        List<Message> messages = (data['messages'] as List)
            .map((item) => Message.fromJson(item))
            .toList();

        conversation.title = title ?? "Conversation";
        conversation.messages = messages;

        for (Message message in messages) {
          for (List<int> complexGlyphIdList in message.glyphIds) {
            ComplexGlyph complexGlyph = GlyphController.instance
                .getComplexGlyphsForGlyphIds(complexGlyphIdList);
            message.glyphs.add(complexGlyph);
          }
        }
      } else {
        print('Failed to read file: ${response.body}');
        return null;
      }
      return conversation;
    } catch (e) {
      return null;
    }
  }

  /// Creates a message
  Message createMessage(String sender, List<ComplexGlyph> complexGlyphs) {
    // Convertir chaque ComplexGlyph en une liste d'IDs
    List<List<int>> glyphIdGroups =
        complexGlyphs.map((complexGlyph) => complexGlyph.ids).toList();

    return Message(
      sender: sender,
      timestamp: DateTime.now(),
      glyphIds: glyphIdGroups,
    );
  }

  /// Validates the [messageBeingWritten] by uploading it on server.
  /// Returns [true] if the operation succeeded.
  Future<bool> validateMessage(Conversation conversation, String sender) async {
    // Message newMessage = createMessageJson(sender, messageBeingWritten);
    Message newMessage = createMessage(sender, messageBeingWritten);
    bool success = await _sendMessage(conversation, newMessage);
    if (success) {
      conversation.messages.add(newMessage);
      clearMessage();
    }
    return success;
  }

  /// Sends a [Message] to the distant file.
  Future<bool> _sendMessage(
      Conversation conversation, Message messageToAdd) async {
    try {
      await loadConversationMessage(conversation); //todo necessary ?
      // Étape 3: Ajouter le nouveau message
      // Message newMessage = createMessage(sender, complexGlyphs);
      conversation.messages.add(messageToAdd);

      String updatedJson = jsonEncode(conversation.toJson());

      // Étape 5: Écrire le nouveau JSON dans le fichier
      // Utilisez ici la méthode pour écrire dans votre fichier sur GitHub
      if (_token != null) {
        bool success =
        await updateFileOnGitHub(conversation.url, updatedJson, _token!);
        return success;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  /// Sends  [content] to a github [url],
  Future<bool> updateFileOnGitHub(
      String url, String content, String token) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});

      if (response.statusCode == 200) {
        final sha = jsonDecode(response.body)['sha'];

        final updateResponse = await http.put(
          Uri.parse(url),
          headers: {
            'Authorization': 'token $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': 'update file',
            'content': base64Encode(utf8.encode(content)),
            'sha': sha,
          }),
        );

        if (updateResponse.statusCode == 200) {
          print('File updated');
          return true;
        } else {
          print('Failed to update file: ${updateResponse.body}');
          return false;
        }
      } else {
        print('Failed to get file: ${response.body}');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }



  Future<String> getToken() async {
    final response = await http.get(
      Uri.parse(gitHubToken),
      headers: {},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }
}
