import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ViaCepService {
  Future<Map<String, String>?> consultarCep(String cep) async {
    final somenteDigitos = cep.replaceAll(RegExp(r'\D'), '');
    if (somenteDigitos.length != 8) {
      throw const FormatException('O CEP precisa ter 8 dígitos.');
    }

    final cliente = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    try {
      final uri = Uri.https(
        'viacep.com.br',
        '/ws/$somenteDigitos/json/',
      );
      final requisicao = await cliente
          .getUrl(uri)
          .timeout(const Duration(seconds: 15));
      final resposta =
          await requisicao.close().timeout(const Duration(seconds: 15));

      if (resposta.statusCode != HttpStatus.ok) {
        throw HttpException(
          'O ViaCEP respondeu com status ${resposta.statusCode}.',
          uri: uri,
        );
      }

      final conteudo = await resposta
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 15));
      final dados = jsonDecode(conteudo);
      if (dados is! Map<String, dynamic>) {
        throw const FormatException('Resposta inválida do ViaCEP.');
      }
      if (dados['erro'] == true) return null;

      return {
        'logradouro': (dados['logradouro'] as String? ?? '').trim(),
        'bairro': (dados['bairro'] as String? ?? '').trim(),
        'localidade': (dados['localidade'] as String? ?? '').trim(),
      };
    } finally {
      cliente.close(force: true);
    }
  }
}
