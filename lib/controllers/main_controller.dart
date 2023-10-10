import '../models/database_manager.dart';
import 'package:http/http.dart' as http;
import '../models/glyph.dart';
import '../utils/constants.dart';

class MainController{

  Future<void> initData() async {
    DatabaseManager db = DatabaseManager.instance;
    await db.initDb();

    final response = await http.get(Uri.parse(glyphUrl));

    if (response.statusCode == 200) {
      final String jsonResult = response.body;
      await db.populateGlyphTable(jsonResult);
    }
  }

  Future<Glyph> getOneGlyph() async {
    List<Glyph> allGlyphs = await DatabaseManager.instance.getAllGlyphs();
    return allGlyphs.first;
  }

  Future<List<Glyph>> getAllGlyphs() async {
    return await DatabaseManager.instance.getAllGlyphs();
  }
}