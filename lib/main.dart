import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/glyph_controller.dart';
import 'package:glyph_project/controllers/message_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/utils/constants.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/views/pages/home_page.dart';
import 'package:glyph_project/views/widgets/splash_screen.dart';

import 'models/glyph.dart';


void main() {
  runApp(MyApp());
  // runApp(TestAnim());

}





class MyApp extends StatelessWidget {

  void test(){
    // Glyph gl1 = GlyphController.instance.glyphs[0];
    // Glyph gl2 = GlyphController.instance.glyphs[1];
    // List<Glyph> gls = [gl1, gl2];
    //
    // ComplexGlyph glyphs = ComplexGlyph(glyphs: gls);
    //
    // List<ComplexGlyph> complexGlyphs = [glyphs];
    // String json =  MessageController.instance.createMessageJson("Quentin", complexGlyphs);
    // MessageController.instance.addMessageToJsonFile("Quentin", complexGlyphs, "conv_1");

    // MessageController.instance.updateFileOnGitHub("conv_1", json, gitHubToken);

  }

  final Future _initialization = _initializeApp();

  MyApp({super.key});

  static Future _initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GlyphController.instance.initData();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // test();
            return HomePage(); // ou votre première page après le chargement
          }
          if (snapshot.hasError) {
            return ErrorPage(); // Une page d'erreur simple si quelque chose ne va pas
          }
          return SplashScreen(); // Votre SplashScreen pendant le chargement des données
        },
      ),
    );
  }
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFFF1D22C),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFF1D22C),
    ).copyWith(
      primary: Color(0xFFF1D22C), // Explicitly set the primary color
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Text color for TextButton
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Text color for ElevatedButton
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // Text color for OutlinedButton
      ),
    ),
    // popupMenuTheme: const PopupMenuThemeData(
    //   color: Colors.white, // Cette propriété définit la couleur de fond des menus contextuels
    //   // Ajoutez ici d'autres personnalisations si nécessaire
    // ),
  );

}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Erreur"),
    );
  }
}
