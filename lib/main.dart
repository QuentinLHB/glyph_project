import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/views/pages/dictionary_page.dart';
import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/views/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainController.instance.initData();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key
  });
  
  void initApp()  {
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initApp();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const HomePage(),
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
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),  // Text color for TextButton
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),  // Text color for ElevatedButton
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),  // Text color for OutlinedButton
      ),
    ),
  );


}

