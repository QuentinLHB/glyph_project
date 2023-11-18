import 'message.dart';

class Conversation{
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  String title = "";



  Conversation();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

}