import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'glyph.dart';


class DatabaseManager{

  // Instance statique privée
  static final DatabaseManager _instance = DatabaseManager._internal();

  // Constructeur interne
  DatabaseManager._internal();

  // Méthode d'accès à l'instance
  static DatabaseManager get instance => _instance;

  static late final  Database _db;

  Future<void> initDb() async {


    try {
      print("DEBUG_DB: initDb started");
      _db = await openDatabase(
        'glyphs.db',
        version: 1,
      );
      // await deleteAllFromTable("glyph");
      // await deleteAllFromTable("glyph_type");
      // await dropTable("glyph");
      // await dropTable("glyph_type");

      await _createTables(_db);

      print("DEBUG_DB: initDb ended");
    } catch (e) {
      print("Erreur lors de l'initialisation de la base de données : $e");
    }
  }


  Future<void> _createTables(Database db) async {
    // Créer la table glyph_type si elle n'existe pas déjà
    await db.execute('''
    CREATE TABLE IF NOT EXISTS glyph_type (
      id INTEGER PRIMARY KEY,
      label TEXT NOT NULL,
      svg TEXT NOT NULL,
      description TEXT
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
  }



  Future<void> populateGlyphTable(String jsonString) async {
    print("DEBUG_DB: populateGlyphTable started");
    final List<dynamic> jsonArray = jsonDecode(jsonString);

    for (var json in jsonArray) {
      final int typeId = json['type_id'];

      // Vérifier si l'élément existe déjà dans la table
      final existingGlyph = await _db.query(
        'Glyph',
        where: 'type_id = ?',
        whereArgs: [typeId],
      );

      // Si l'élément n'existe pas, alors insérez-le
      if (existingGlyph.isEmpty) {
        await _db.insert('Glyph', {
          'type_id': typeId,
          'label': json['label'],
          'svg': json['svg'],
          'description': json['description'],
          'translation': json['translation'],
        });
      }
    }
  }


  Future<void> populateGlyphTypes() async {
    // Liste des types de glyph en dur
    List<Map<String, Object>> glyphTypes = [
      {'label': 'sujet', 'svg': 'SVG_pour_sujet', 'description': 'Catégorie pour les sujets'},
      {'label': 'verbe', 'svg': 'SVG_pour_verbe', 'description': 'Catégorie pour les verbes'},
    ];

    // Insérer chaque type de glyph dans la table
    for (var glyphType in glyphTypes) {
      await _db.insert('glyph_type', glyphType);
    }
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





}