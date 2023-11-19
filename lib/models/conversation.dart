import 'message.dart';

class Conversation{
  String _url = "";

  String get url => _url;
  List<Message> _messages = [];

  set messages(List<Message> value) {
    _messages = value;
  }

  List<Message> get messages => _messages;

  String _title = "";

  set title(String value) {
    _title = value;
  }

  String get title => _title;


  Conversation(String url){
    _url = url;
  }

  // Conversation();
  Conversation.loaded(String url, String title, List<Message> messages){
    _url = url;
    _title = title;
    _messages = messages;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': _title,
      'messages': _messages.map((message) => message.toJson()).toList(),
    };
  }

}