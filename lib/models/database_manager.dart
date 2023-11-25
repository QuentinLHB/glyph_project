import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'glyph.dart';
import 'glyph_type.dart';

class DatabaseManager {
  // Instance statique privée
  static final DatabaseManager _instance = DatabaseManager._internal();

  DatabaseManager._internal();

  static DatabaseManager get instance => _instance;

  static late final Database _db;

  Future<void> initDb() async {
    try {
      print("DEBUG_DB: initDb started");
      _db = await openDatabase(
        'glyphs.db',
        version: 1,
      );
      // await deleteAllFromTable("glyph_type");
      // await deleteAllFromTable("glyph");
      // await dropTable("glyph");
      // await dropTable("glyph_type");

      await _createTables(_db);

      print("DEBUG_DB: initDb ended");
    } catch (e) {
      print(
          "DEBUG_DB : Erreur lors de l'initialisation de la base de données : $e");
    }
  }

  Future<void> _createTables(Database db) async {
    // Créer la table glyph_type si elle n'existe pas déjà
    await db.execute('''
  CREATE TABLE IF NOT EXISTS glyph_type (
    id INTEGER PRIMARY KEY,
    label TEXT NOT NULL,
    svg TEXT NOT NULL,
    description TEXT,
    isMergeable INTEGER NOT NULL
  );
''');

    // Créer la table Glyph si elle n'existe pas déjà
    await db.execute('''
    CREATE TABLE IF NOT EXISTS glyph (
      id INTEGER PRIMARY KEY,
      type_id INTEGER NOT NULL,
      label TEXT NOT NULL,
      svg TEXT NOT NULL,
      description TEXT,
      translation TEXT,
      FOREIGN KEY (type_id) REFERENCES glyph_type (id)
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS glyph_versions (
      id INTEGER PRIMARY KEY,
      key TEXT NOT NULL,
      version TEXT NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS app_parameters (
      id INTEGER PRIMARY KEY,
      key TEXT NOT NULL,
      value TEXT NULL
    );
  ''');
  }

  Future<void> updateVersionForKey(String key, String version) async {
    // Vérifier si une entrée avec cette clé existe déjà
    final existingVersion = await _db.query(
      'glyph_versions',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (existingVersion.isEmpty) {
      // Si l'entrée n'existe pas, alors insérez une nouvelle ligne
      await _db.insert('glyph_versions', {
        'key': key,
        'version': version,
      });
    } else {
      // Si l'entrée existe, alors mettez-la à jour
      await _db.update(
        'glyph_versions',
        {'version': version},
        where: 'key = ?',
        whereArgs: [key],
      );
    }
  }

  Future<void> populateGlyphTable(String jsonString) async {
    print("DEBUG_DB: populateGlyphTable started");

    await deleteAllFromTable("glyph");
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    final List<dynamic> jsonArray = decodedJson[
        'glyphs']; // Extraction des glyphes à partir de la clé 'glyphs'
    for (var json in jsonArray) {
      final int id = json['id'];
      // Si l'élément n'existe pas, alors insérez-le

      await _db.insert('Glyph', {
        'id': id,
        'type_id': json['type_id'],
        'label': json['label'],
        'svg': json['svg'],
        'description': json['description'],
        'translation': json['translation'],
      });
    }
  }

  Future<void> populateGlyphTypesTable(String jsonString) async {
    print("DEBUG_DB: populateGlyphTypes started");

    await deleteAllFromTable("glyph_type");
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    final List<dynamic> jsonArray = decodedJson[
        'glyphTypes']; // Extraction des types de glyphes à partir de la clé 'glyphTypes'

    for (var json in jsonArray) {
      final int id = json['id'];

      await _db.insert('glyph_type', {
        'id': id,
        'label': json['label'],
        'svg': json['svg'],
        'description': json['description'],
        'isMergeable': json['isMergeable'] ? 1 : 0,
        // Gestion de booléens en SQLite: 1 pour vrai, 0 pour faux
      });
    }
    print("DEBUG_DB: populateGlyphTypes finished");
  }

  /// Gets all glyphs
  Future<List<Glyph>> getAllGlyphs() async {
    final List<Map<String, dynamic>> maps = await _db.query('glyph');

    return List.generate(maps.length, (i) {
      return Glyph.fromMap(maps[i]);
    });
  }

  Future<void> deleteAllFromTable(String table) async {
    await _db.delete(table);
  }

  Future<void> dropTable(String table) async {
    await _db.execute('DROP TABLE IF EXISTS ${table}');
  }

  Future<List<GlyphType>> getAllGlyphTypes() async {
    final List<Map<String, dynamic>> maps = await _db.query('glyph_type');

    return List.generate(maps.length, (i) {
      return GlyphType(
        id: maps[i]['id'],
        label: maps[i]['label'],
        svg: maps[i]['svg'],
        description: maps[i]['description'],
        isMergeable: maps[i]['isMergeable'] == 1,
      );
    });
  }

  Future<String?> getParameter(String key) async{
    final List<Map<String, dynamic>> results = await _db.query(
      'app_parameters',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (results.isNotEmpty) {
      return results.first['value'] as String;
    } else {
      return null;
    }
  }

  Future<bool> updateParameter(String key, String newValue) async {
    int updated = await _db.update(
      'app_parameters',
      {'value': newValue},
      where: 'key = ?',
      whereArgs: [key],
    );

    if (updated > 0) {
      // Si la mise à jour a réussi, retourne vrai
      return true;
    } else {
      // Si aucune ligne n'a été mise à jour, insère une nouvelle ligne
      int inserted = await _db.insert(
        'app_parameters',
        {'key': key, 'value': newValue},
      );
      return inserted > 0; // Retourne vrai si l'insertion a réussi
    }
  }



  Future<String> getVersionForKey(String key) async {
    final List<Map<String, dynamic>> results = await _db.query(
      'glyph_versions',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (results.isNotEmpty) {
      return results.first['version'] as String ?? "0";
    } else {
      return "0";
    }
  }

  Future<List<Glyph>> getMergeableGlyphs() async {
    List<Glyph> mergeableGlyphs = [];
    const String query = '''
    SELECT g.* FROM glyph AS g
    JOIN glyph_type AS gt ON g.type_id = gt.id
    WHERE gt.isMergeable = 1;
  ''';

    List<Map<String, dynamic>> result = await _db.rawQuery(query);

    for (Map<String, dynamic> row in result) {
      mergeableGlyphs.add(Glyph.fromMap(row));  // Hypothèse : Vous avez une méthode de conversion .fromMap() sur votre modèle Glyph
    }

    return mergeableGlyphs;
  }

}
