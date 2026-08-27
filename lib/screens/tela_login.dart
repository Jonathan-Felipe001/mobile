import 'package:flutter/material.dart';
import '../models/sessao_model.dart';
import '../services/database_service.dart';
import '../services/preferencias_service.dart';
import 'tela_cadastro.dart';
import 'home_page.dart';

class TelaLogin extends StatefulWidget {
  final bool exibirVoltar;

  TelaLogin({this.exibirVoltar = false});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _mostrarSenha = false;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    final usuario = await DatabaseService.instance.autenticarUsuario(
      _emailController.text,
      _senhaController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (usuario == null || usuario.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("E-mail ou senha inválidos."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await PreferenciasService().salvarSessao(
      SessaoModel(
        usuarioId: usuario.id!,
        nome: usuario.nome,
        email: usuario.email,
      ),
    );

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        leading: widget.exibirVoltar
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
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
                        Icons.lock_outline,
                        color: Colors.blue,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Acesse sua conta",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
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
                          return "Informe sua senha";
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
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _entrar,
                        child: _carregando
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text("Entrar"),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaCadastro(),
                            ),
                          );
                        },
                        child: Text("Ainda não tenho uma conta"),
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