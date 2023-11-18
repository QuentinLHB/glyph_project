import 'package:glyph_project/models/complex_glyph.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/message.dart';

class MessageController {
  static final MessageController _instance = MessageController._internal();

  MessageController._internal();

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

  Future<void> addMessageToJsonFile(String sender, List<ComplexGlyph> complexGlyphs, String filePath, String token) async {
    String apiUrl = 'https://api.github.com/repos/QuentinLHB/glyph_conv/contents/$filePath';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.v3.raw',
      },
    );
    if (response.statusCode == 200) {
      // Étape 2: Décoder le contenu JSON
      var data = jsonDecode(response.body);
      var messages = (data['messages'] as List).map((item) => Message.fromJson(item)).toList();

      // Étape 3: Ajouter le nouveau message
      Message newMessage = createMessage(sender, complexGlyphs);
      messages.add(newMessage);

      // Étape 4: Réencoder la liste en JSON
      data['messages'] = messages.map((message) => message.toJson()).toList();
      String updatedJson = jsonEncode(data);

      // Étape 5: Écrire le nouveau JSON dans le fichier
      // Utilisez ici la méthode pour écrire dans votre fichier sur GitHub
      await updateFileOnGitHub('https://api.github.com/repos/QuentinLHB/glyph_conv/contents/$filePath', updatedJson, token);
    } else {
      print('Failed to read file: ${response.body}');
    }
  }




}
