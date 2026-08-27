import 'package:shared_preferences/shared_preferences.dart';
import '../models/sessao_model.dart';

class PreferenciasService {
  static const _usuarioIdKey = 'sessao_usuario_id';
  static const _nomeKey = 'sessao_nome';
  static const _emailKey = 'sessao_email';

  Future<void> salvarSessao(SessaoModel sessao) async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.setInt(_usuarioIdKey, sessao.usuarioId);
    await preferencias.setString(_nomeKey, sessao.nome);
    await preferencias.setString(_emailKey, sessao.email);
  }

  Future<SessaoModel?> obterSessao() async {
    final preferencias = await SharedPreferences.getInstance();
    final usuarioId = preferencias.getInt(_usuarioIdKey);
    final nome = preferencias.getString(_nomeKey);
    final email = preferencias.getString(_emailKey);

    if (usuarioId == null || nome == null || email == null) {
      return null;
    }

    return SessaoModel(
      usuarioId: usuarioId,
      nome: nome,
      email: email,
    );
  }

  Future<bool> possuiSessaoAtiva() async {
    return (await obterSessao()) != null;
  }

  Future<void> encerrarSessao() async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.remove(_usuarioIdKey);
    await preferencias.remove(_nomeKey);
    await preferencias.remove(_emailKey);
  }
}