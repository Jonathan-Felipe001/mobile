import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Venda de Cursos",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 6,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            elevation: 4,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.blueAccent),
      ),
      home: const SplashScreen(),
    );
  }
}
=================================================================================
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MeuAppCursos());
}

class MeuAppCursos extends StatelessWidget {
  const MeuAppCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaCadastroSimples(),
    );
  }
}

class TelaCadastroSimples extends StatefulWidget {
  const TelaCadastroSimples({super.key});

  @override
  State<TelaCadastroSimples> createState() => _TelaCadastroSimplesState();
}

class _TelaCadastroSimplesState extends State<TelaCadastroSimples> {
  final TextEditingController _cepController = TextEditingController();
  String _rua = '';
  String _cidade = '';
  bool _carregando = false;

  // Função que vai na API do ViaCEP buscar o endereço
  Future<void> buscarCEP() async {
    final cep = _cepController.text.trim().replaceAll('-', '');
    
    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um CEP válido com 8 números.')),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    final url = Uri.parse('https://viacep.com.br');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);

        if (dados['erro'] == true) {
          setState(() {
            _rua = 'CEP não encontrado';
            _cidade = '';
          });
        } else {
          setState(() {
            _rua = dados['logradouro'] ?? 'Sem rua';
            _cidade = '${dados['localidade']} - ${dados['uf']}';
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao conectar na API.')),
      );
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro do Aluno (Simulado)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Preencha seu endereço para o checkout:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP (Ex: 01001000)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _carregando ? null : buscarCEP,
              child: _carregando 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Buscar Endereço'),
            ),
            const SizedBox(height: 30),
            Text('Rua: $_rua', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Cidade: $_cidade', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
