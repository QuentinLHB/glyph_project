import 'dart:convert';

import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';

import '../models/database_manager.dart';
import 'package:http/http.dart' as http;
import '../models/glyph.dart';
import '../utils/constants.dart';

class MainController {
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

    final glyphTypesresponse = await http.get(Uri.parse(glyphTypesUrl));
    if (glyphTypesresponse.statusCode == 200) {
      final String jsonResult = glyphTypesresponse.body;
      if (await MainController.instance.shouldUpdateDatabase(
          "glyph_type", jsonResult)) await db.populateGlyphTypesTable(jsonResult);
    }

    await initAllGlyphTypes();

    final response = await http.get(Uri.parse(glyphUrl));

    if (response.statusCode == 200) {
      final String jsonResult = response.body;
      if (await MainController.instance.shouldUpdateDatabase(
          "glyph", jsonResult)) await db.populateGlyphTable(jsonResult);
    }

    await initAllGlyphs();
  }

  Future<Glyph> getOneGlyph() async {
    List<Glyph> allGlyphs = await DatabaseManager.instance.getAllGlyphs();
    return allGlyphs.first;
  }

  Future<List<Glyph>> initAllGlyphs() async {
    if (_glyphs.isEmpty) {
      _glyphs = await DatabaseManager.instance.getAllGlyphs();
    }
    return _glyphs;
  }

  Future<List<GlyphType>> initAllGlyphTypes() async {
    if (_glyphTypes.isEmpty) {
      _glyphTypes = await DatabaseManager.instance.getAllGlyphTypes();
    }
    return _glyphTypes;
  }

  List<ComplexGlyph> getGlyphsForType(GlyphType type) {
    List<Glyph> glyphsForType =
        _glyphs.where((glyph) => glyph.typeId == type.getId).toList();

    // Convertir chaque Glyph en ComplexGlyph avec une liste contenant un seul Glyph
    List<ComplexGlyph> complexGlyphs =
        glyphsForType.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return complexGlyphs;
  }

  List<ComplexGlyph> getGlyphsForTypeId(int typeId) {
    List<Glyph> glyphsForType =
        _glyphs.where((glyph) => glyph.typeId == typeId).toList();

    // Convertir chaque Glyph en ComplexGlyph avec une liste contenant un seul Glyph
    List<ComplexGlyph> complexGlyphs =
        glyphsForType.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return complexGlyphs;
  }

  ComplexGlyph fuseGlyphs(List<Glyph> glyphsToFuse) {
    return ComplexGlyph(glyphs: glyphsToFuse);
  }

  Future<bool> shouldUpdateDatabase(String key, String jsonString) async {
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    final double versionDouble = decodedJson['version'];
    final String distantVersion = versionDouble.toString();
    String currentVersion =
        await DatabaseManager.instance.getVersionForKey(key);
    bool shouldUpdate = currentVersion != distantVersion;
    print("JSON version : $distantVersion, DB version : $currentVersion (shouldUpdate : $shouldUpdate)");
    if(shouldUpdate){
      await DatabaseManager.instance.updateVersionForKey(key, distantVersion);
    }
    return shouldUpdate;
  }
}
