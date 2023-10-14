import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';

import '../models/database_manager.dart';
import 'package:http/http.dart' as http;
import '../models/glyph.dart';
import '../utils/constants.dart';

class MainController{

  static final MainController _instance = MainController._internal();
  MainController._internal();
  static MainController get instance => _instance;

  List<Glyph> _glyphs = <Glyph>[];
  List<GlyphType> _glyphTypes = <GlyphType>[];


  List<Glyph> get glyphs => _glyphs;
  List<GlyphType> get glyphTypes => _glyphTypes;

  Future<void> initData() async {
    DatabaseManager db = DatabaseManager.instance;
    await db.initDb();

    await db.populateGlyphTypes();
    await initAllGlyphTypes();

    final response = await http.get(Uri.parse(glyphUrl));

    if (response.statusCode == 200) {
      final String jsonResult = response.body;
      await db.populateGlyphTable(jsonResult);
    }

    await initAllGlyphs();

  }

  Future<Glyph> getOneGlyph() async {
    List<Glyph> allGlyphs = await DatabaseManager.instance.getAllGlyphs();
    return allGlyphs.first;
  }

  Future<List<Glyph>> initAllGlyphs() async {
    if(_glyphs.length == 0){
      _glyphs = await DatabaseManager.instance.getAllGlyphs();
    }
    return _glyphs;
  }

  Future<List<GlyphType>> initAllGlyphTypes() async {
    if(_glyphTypes.length == 0){
      _glyphTypes = await DatabaseManager.instance.getAllGlyphTypes();
    }
    return _glyphTypes;
  }

  List<ComplexGlyph> getGlyphsForType(GlyphType type) {
    List<Glyph> glyphsForType = _glyphs.where((glyph) => glyph.typeId == type.getId).toList();

    // Convertir chaque Glyph en ComplexGlyph avec une liste contenant un seul Glyph
    List<ComplexGlyph> complexGlyphs = glyphsForType.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return complexGlyphs;
  }

  List<ComplexGlyph> getGlyphsForTypeId(int typeId) {
    List<Glyph> glyphsForType = _glyphs.where((glyph) => glyph.typeId == typeId).toList();

    // Convertir chaque Glyph en ComplexGlyph avec une liste contenant un seul Glyph
    List<ComplexGlyph> complexGlyphs = glyphsForType.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return complexGlyphs;
  }


  ComplexGlyph fuseGlyphs(List<Glyph> glyphsToFuse) {
    return ComplexGlyph(glyphs: glyphsToFuse);
  }

}