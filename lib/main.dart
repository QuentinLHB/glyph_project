import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/views/pages/home_page.dart';
import 'package:glyph_project/views/widgets/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.black), // Text color for TextButton
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.black), // Text color for ElevatedButton
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.black), // Text color for OutlinedButton
      ),
    ),
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
