import 'package:flutter/material.dart';
import 'package:glyph_project/views/pages/conversation_page.dart';

class ConversationsListPage extends StatelessWidget {
  const ConversationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(onPressed: () => {
      MaterialPageRoute(builder: (context) => ConversationPage()),
    }, child: const Text("conv"));
  }
}
