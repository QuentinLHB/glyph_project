import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/views/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainController.instance.initData();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key
  });
  
  void initApp()  {
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }

  // ThemeData customTheme = ThemeData(
  //   primarySwatch: Colors.orange, // Couleur principale de l'application
  //   textTheme: const TextTheme(
  //     // Styles de texte par défaut
  //     displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
  //     bodyLarge: TextStyle(fontSize: 16.0, color: Colors.grey),
  //   ),
  // );

}

