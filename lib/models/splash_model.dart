import '../services/preferencias_service.dart';

class SplashModel {
  final PreferenciasService _preferenciasService;

  SplashModel({PreferenciasService? preferenciasService})
      : _preferenciasService =
            preferenciasService ?? PreferenciasService();

  Future<bool> possuiSessaoAtiva() async {
    return _preferenciasService.possuiSessaoAtiva();
  }
}