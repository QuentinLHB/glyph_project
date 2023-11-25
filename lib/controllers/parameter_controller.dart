import 'package:glyph_project/models/database_manager.dart';
import 'package:glyph_project/utils/constants.dart';

class ParameterController {
  static final ParameterController _instance = ParameterController._internal();

  ParameterController._internal();

  String? pseudo;
  final String pseudoParameter = "pseudo";

  static ParameterController get instance => _instance;

  Future<String> getPseudo() async{
    String? pseudo = await DatabaseManager.instance.getParameter(pseudoParameter);
    if(pseudo == null) pseudo = defaultPseudo;
    return pseudo;
  }

  Future<bool> setPseudo(String pseudo) async {
    return await DatabaseManager.instance.updateParameter(pseudoParameter, pseudo);
  }

}