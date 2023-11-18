import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/conversation.dart';
import '../models/message.dart';

class MessageController {

  late String _token;
  static final MessageController _instance = MessageController._internal();

  MessageController._internal(){
    initToken();
  }

  Future<void> initToken() async{
    _token = await getToken();
  }

  static MessageController get instance => _instance;

  final List<ComplexGlyph> _messageBeingWritten = <ComplexGlyph>[];

  List<ComplexGlyph> get messageBeingWritten => _messageBeingWritten;

  void addGlyph(ComplexGlyph newGlyph) {
    messageBeingWritten.add(newGlyph);
  }

  void modifyGlyph(ComplexGlyph glyphToModify, ComplexGlyph newGlyph) {
    int index = messageBeingWritten
        .indexWhere((item) => identical(item, glyphToModify));
    messageBeingWritten.removeAt(index);
    messageBeingWritten.insert(index, newGlyph);
  }

  void deleteGlyph(ComplexGlyph glyphToDelete) {
    messageBeingWritten.removeWhere((item) => identical(item, glyphToDelete));
  }

  void clearMessage() {
    messageBeingWritten.clear();
  }

  Future<void> updateFileOnGitHub(String filePath, String content, String token) async {
    final response = await http.get(Uri.parse(filePath), headers: {
      'Authorization': 'token $token'
    });

    if (response.statusCode == 200) {
      final sha = jsonDecode(response.body)['sha'];

      final updateResponse = await http.put(
        Uri.parse(filePath),
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
      } else {
        print('Failed to update file: ${updateResponse.body}');
      }
    } else {
      print('Failed to get file: ${response.body}');
    }
  }

  Message createMessage(String sender, List<ComplexGlyph> complexGlyphs) {
    // Convertir chaque ComplexGlyph en une liste d'IDs
    List<List<int>> glyphIdGroups = complexGlyphs.map((complexGlyph) => complexGlyph.ids).toList();

    return Message(
      sender: sender,
      timestamp: DateTime.now(),
      glyphs: glyphIdGroups,
    );
  }


  String createMessageJson(String sender, List<ComplexGlyph> glyphs) {
    Message message = createMessage(sender, glyphs);
    String jsonMessage = jsonEncode(message.toJson());
    return jsonMessage;
  }

  // Future<Conversation?> getConversation(Conversation conversation) async {
  //   final response = await http.get(
  //     Uri.parse(conversation.url),
  //     headers: {
  //       'Authorization': 'token $_token',
  //       'Accept': 'application/vnd.github.v3.raw',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // Étape 2: Décoder le contenu JSON
  //     var data = jsonDecode(response.body);
  //
  //     String title = data['title'];
  //     List<Message> messages = (data['messages'] as List).map((item) =>
  //         Message.fromJson(item)).toList();
  //
  //     return Conversation.loaded(title, conversation.url);
  //   }else {
  //     print('Failed to read file: ${response.body}');
  //     return null;
  //   }
  // }

  Future<Conversation?> loadConversationMessage(Conversation conversation) async{
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

      String title = data['title'];
      List<Message> messages = (data['messages'] as List).map((item) =>
          Message.fromJson(item)).toList();

      conversation.title = title;
      conversation.messages = messages;
    }else {
      print('Failed to read file: ${response.body}');
      return null;
    }
  }

  Future<void> addMessageToJsonFile(Conversation conversation, Message messageToAdd) async {
      await loadConversationMessage(conversation); //todo necessary ?
      // Étape 3: Ajouter le nouveau message
      // Message newMessage = createMessage(sender, complexGlyphs);
      conversation.messages.add(messageToAdd);

      String updatedJson = jsonEncode(conversation.toJson());

      // Étape 5: Écrire le nouveau JSON dans le fichier
      // Utilisez ici la méthode pour écrire dans votre fichier sur GitHub
      await updateFileOnGitHub(conversation.url, updatedJson, _token);
  }

  Future<String> getToken() async{
    final response = await http.get(
      Uri.parse(gitHubToken),
      headers: {
      },
    );
    if (response.statusCode == 200){
      return response.body;
    }else{
      return "";
    }
  }








}
