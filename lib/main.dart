import 'package:flutter/material.dart';
import 'package:glyph_project/controllers/main_controller.dart';
import 'package:glyph_project/views/home_page.dart';
import 'package:glyph_project/models/database_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainController().initData();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key
  });
  
  void initApp()  {
    MainController().initData();
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
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

