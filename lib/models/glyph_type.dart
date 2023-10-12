class GlyphType {
  final int id;
  final String label;
  final String svg;
  final String description;

  GlyphType({required this.id, required this.label, required this.svg, required this.description});

  int get getId => id;
  String get getLabel => label;
  String get getSvg => svg;
  String get getDescription => description;
}
