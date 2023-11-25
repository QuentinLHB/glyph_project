import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/glyph_controller.dart';
import 'package:glyph_project/views/pages/conversation_page.dart';
import 'package:glyph_project/views/pages/conversations_list_page.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/views/pages/write_message.dart';
import 'package:glyph_project/views/widgets/translated_text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const double glyphSize = 50;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const TranslatedTextWidget("gline", size: glyphSize),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TranslatedTextWidget(
                      "Menu",
                      size:glyphSize,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const TranslatedTextWidget("gline", size: glyphSize, textAlign: TextAlign.start,),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: const TranslatedTextWidget("mot+verbe", size: glyphSize, textAlign: TextAlign.start,),
                onTap: () {
                  // Ici, mettez votre navigation vers la page Messagerie
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TranslatedTextWidget(
               'salut',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                size: glyphSize,
              ),
              const SizedBox(height: 20),
              // const TranslatedTextWidget(
              //   'je+pluriel amour',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16),
              // ), //test
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryPage()));
                },
                child: TranslatedTextWidget('gline', size: 40,),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationsListPage()));
                },
                child: const TranslatedTextWidget('mot+verbe', size: glyphSize,),
              ),
            ],
          ),
        ),
      );
  }

}
