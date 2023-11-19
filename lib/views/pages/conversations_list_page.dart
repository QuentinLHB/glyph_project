import 'package:flutter/material.dart';
import 'package:glyph_project/views/pages/conversation_page.dart';

import '../../models/conversation.dart';

class ConversationsListPage extends StatelessWidget {
  const ConversationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo get All files from repo
    Conversation conv = Conversation(
        "https://api.github.com/repos/QuentinLHB/glyph_conv/contents/conv_1");
    return ElevatedButton(
        onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConversationPage(
                        conversation: conv,
                      ))),
            },
        child: const Text("conv"));
  }
}
