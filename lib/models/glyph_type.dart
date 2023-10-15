class GlyphType {
  final int id;
  final String label;
  final String svg;
  final String description;
  final bool _isMergeable;

  GlyphType({required this.id, required this.label, required this.svg, required this.description, required bool isMergeable}) : _isMergeable = isMergeable;

  int get getId => id;
  String get getLabel => label;
  String get getSvg => svg;
  String get getDescription => description;
  bool get isMergeable => _isMergeable;

}
