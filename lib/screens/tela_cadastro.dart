import 'package:flutter/material.dart';
import '../models/sessao_model.dart';
import '../models/usuario_model.dart';
import '../services/database_service.dart';
import '../services/preferencias_service.dart';
import 'home_page.dart';
import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      final email = _emailController.text.trim().toLowerCase();
      final usuarioId = await DatabaseService.instance.inserirUsuario(
        UsuarioModel(
          nome: _nomeController.text.trim(),
          email: email,
          senha: _senhaController.text,
        ),
      );

      await PreferenciasService().salvarSessao(
        SessaoModel(
          usuarioId: usuarioId,
          nome: _nomeController.text.trim(),
          email: email,
        ),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Este e-mail já está cadastrado."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 600),
          builder: (context, valor, child) {
            return Opacity(
              opacity: valor,
              child: Transform.translate(
                offset: Offset(0, (1 - valor) * 30),
                child: child,
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.person_add_alt_1,
                        color: Colors.blue,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Crie sua conta",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _nomeController,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "Informe seu nome completo";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Nome completo",
                        prefixIcon: Icon(Icons.person),
                        suffixText: "*",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "Informe seu e-mail";
                        }
                        if (!valor.contains("@") || !valor.contains(".")) {
                          return "Informe um e-mail válido";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email),
                        suffixText: "*",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_mostrarSenha,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "Crie uma senha";
                        }
                        if (valor.length < 6) {
                          return "A senha deve ter pelo menos 6 caracteres";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Senha",
                        prefixIcon: Icon(Icons.lock),
                        suffixText: "*",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: !_mostrarConfirmacao,
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return "Confirme sua senha";
                        }
                        if (valor != _senhaController.text) {
                          return "As senhas não conferem";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Confirmar senha",
                        prefixIcon: Icon(Icons.lock_reset),
                        suffixText: "*",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarConfirmacao
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarConfirmacao = !_mostrarConfirmacao;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _cadastrar,
                        child: _carregando
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text("Cadastrar"),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaLogin(),
                            ),
                          );
                        },
                        child: Text("Já tenho uma conta"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}