import 'dart:convert';

import 'package:glyph_project/controllers/message_controller.dart';
import 'package:glyph_project/models/complex_glyph.dart';
import 'package:glyph_project/models/glyph_type.dart';

import '../models/database_manager.dart';
import 'package:http/http.dart' as http;
import '../models/glyph.dart';
import '../utils/constants.dart';

class GlyphController {
  static final GlyphController _instance = GlyphController._internal();

  GlyphController._internal();

  static GlyphController get instance => _instance;

  List<Glyph> _glyphs = <Glyph>[];
  List<GlyphType> _glyphTypes = <GlyphType>[];

  List<Glyph> get glyphs => _glyphs;

  List<GlyphType> get glyphTypes => _glyphTypes;

  Future<void> initData() async {
    DatabaseManager db = DatabaseManager.instance;
    await db.initDb();

    await MessageController.instance.initToken(); // inits token

    final glyphTypesresponse = await http.get(
      Uri.parse(glyphTypesUrl),
      headers: {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    );

    if (glyphTypesresponse.statusCode == 200) {
      final String jsonResult = glyphTypesresponse.body;
      if (await GlyphController.instance
          .shouldUpdateDatabase("glyph_type", jsonResult))
        await db.populateGlyphTypesTable(jsonResult);
    }

    await initAllGlyphTypes();

    final response = await http.get(
      Uri.parse(glyphUrl),
      headers: {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    );

    if (response.statusCode == 200) {
      final String jsonResult = response.body;
      if (await GlyphController.instance.shouldUpdateDatabase(
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
    return getComplexGlyphsForTypeId(type.id);
  }

  List<ComplexGlyph> getComplexGlyphsForTypeId(int typeId) {
    List<Glyph> glyphsForType = getGlyphsForTypeId(typeId);

    // Convertir chaque Glyph en ComplexGlyph avec une liste contenant un seul Glyph
    List<ComplexGlyph> complexGlyphs =
        glyphsForType.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return complexGlyphs;
  }

  ComplexGlyph getComplexGlyphsForGlyphIds(List<int> glyphIds) {
    List<Glyph> glyphs = [];
    for(int i in glyphIds){

      List<Glyph> glyphsForType = _glyphs.where((glyph) => glyph.typeId == glyphIds).toList();
      Glyph foundGlyph = glyphsForType.isNotEmpty ? glyphsForType.first :  Glyph.empty();

      glyphs.add(foundGlyph);
    }

    return ComplexGlyph(glyphs: glyphs);
  }

  List<Glyph> getGlyphsForTypeId(int typeId) {
    return _glyphs.where((glyph) => glyph.typeId == typeId).toList();
  }




  ComplexGlyph mergeGlyphs(List<Glyph> glyphsToFuse) {
    return ComplexGlyph(glyphs: glyphsToFuse);
  }

  /// Returns true if the version retreived from the JSON is different from
  /// the one stored in local DB.
  Future<bool> shouldUpdateDatabase(String key, String jsonString) async {
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    final double versionDouble = decodedJson['version'];
    final String distantVersion = versionDouble.toString();
    String currentVersion =
        await DatabaseManager.instance.getVersionForKey(key);
    bool shouldUpdate = currentVersion != distantVersion;
    print(
        "JSON version : $distantVersion, DB version : $currentVersion (shouldUpdate : $shouldUpdate)");
    if (shouldUpdate) {
      await DatabaseManager.instance.updateVersionForKey(key, distantVersion);
    }
    return shouldUpdate;
  }

  Future<List<ComplexGlyph>> getMergeableComplexGlyphs() async {
    List<Glyph> mergeableGlyphs =
        await DatabaseManager.instance.getMergeableGlyphs();
    // Transformez ensuite chaque Glyph en un ComplexGlyph avec ce Glyph comme seul élément
    List<ComplexGlyph> mergeableComplexGlyphs =
        mergeableGlyphs.map((glyph) => ComplexGlyph(glyphs: [glyph])).toList();

    return mergeableComplexGlyphs;
  }

  Future<List<Glyph>> getMergeableGlyphs() async {
    return
        await DatabaseManager.instance.getMergeableGlyphs();
  }

  List<ComplexGlyph>? convertStringToGlyphs(String input) {
    List<ComplexGlyph> complexResult = [];

    // Diviser la chaîne d'entrée par les espaces pour obtenir des groupes de mots
    List<String> groups = input.split(' ');

    for (String group in groups) {
      // Diviser chaque groupe par le symbole "+"
      List<String> subWords = group.split('+');
      List<Glyph> subGlyphs = [];

      for (String word in subWords) {
        // Chercher le glyph correspondant
        List<Glyph> matchingGlyphs = _glyphs
            .where(
              (glyph) => glyph.label.toLowerCase() == word.toLowerCase(),
            )
            .toList();

        if (matchingGlyphs.isEmpty) {
          // Si on ne trouve pas le glyph pour un des mots, retourner null
          return null;
        } else {
          subGlyphs.add(matchingGlyphs.first);
        }
      }

      ComplexGlyph complexGlyph = ComplexGlyph(glyphs: subGlyphs);
      complexResult.add(complexGlyph);
    }

    if (complexResult.isEmpty) return null;
    return complexResult;
  }

  List<ComplexGlyph> convertGlyphsIntoComplexGlyphs(
      List<Glyph> glyphsToConvert) {
    return glyphsToConvert.map((gl) => ComplexGlyph(glyphs: [gl])).toList();
  }

  ComplexGlyph convertGlyphIntoComplexGlyph(
      Glyph glyphToConvert) {
    return  ComplexGlyph(glyphs: [glyphToConvert]);
  }


}
