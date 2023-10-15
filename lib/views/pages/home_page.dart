import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/views/widgets/translated_text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TranslatedTextWidget(text: "oui",),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Menu",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text("Dictionnaire"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("Messagerie"),
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
              Text(
                'Bienvenue!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenue sur notre application. Explorez les fonctionnalités via le menu ou utilisez les boutons ci-dessous.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DictionaryPage()));
                },
                child: Text('Dictionnaire'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Ici, mettez votre navigation vers la page Messagerie
                },
                child: Text('Messagerie'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
