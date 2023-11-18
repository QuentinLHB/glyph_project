class Glyph {
  final int _id;
  final int _typeId;
  final String _label;
  final String _svg;
  final String? _description;
  final String? _translation;

  Glyph({
    required int id,
    required int typeId,
    required String label,
    required String svg,
    String? description,
    String? translation,
  })  : _id = id,
        _typeId = typeId,
        _label = label,
        _svg = svg,
        _description = description,
        _translation = translation;

  int get id => _id;
  int get typeId => _typeId;
  String get label => _label;
  String get svg => _svg;
  String? get description => _description;
  String? get translation => _translation;

  // Méthode pour convertir un Map en Glyph, utile pour la lecture de la base de données
  factory Glyph.fromMap(Map<String, dynamic> map) {
    return Glyph(
      id: map['id'],
      typeId: map['type_id'],
      label: map['label'],
      svg: map['svg'],
      description: map['description'],
      translation: map['translation'],
    );
  }

  // Méthode pour convertir un Glyph en Map, utile pour l'insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'type_id': _typeId,
      'label': _label,
      'svg': _svg,
      'description': _description,
      'translation': _translation,
    };
  }

  static Glyph empty() {
    return Glyph(
      id: -1,
      typeId: 0,  // ou un autre valeur par défaut pour le typeId
      label: '',
      svg: '<svg></svg>',  // un SVG vide
      description: '',
      translation: '',
    );
  }
}
