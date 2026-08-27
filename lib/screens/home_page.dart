import 'package:flutter/material.dart';

import '../models/curso_model.dart';
import '../models/sessao_model.dart';
import '../services/database_service.dart';
import '../services/preferencias_service.dart';
import '../widgets/curso_card.dart';
import 'gerenciar_dados.dart';
import 'tela_login.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Future<List<CursoModel>> _cursosFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..forward();
    _cursosFuture = DatabaseService.instance.listarCursos();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    final inicio = (index * 0.15).clamp(0.0, 1.0).toDouble();
    final fim = (inicio + 0.6).clamp(0.0, 1.0).toDouble();
    final animacao = CurvedAnimation(
      parent: _controller,
      curve: Interval(inicio, fim, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animacao,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animacao),
        child: child,
      ),
    );
  }

  Future<void> _abrirGerenciamento() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GerenciarDados()),
    );
    if (!mounted) return;
    setState(() {
      _cursosFuture = DatabaseService.instance.listarCursos();
    });
  }

  Future<void> _sair() async {
    await PreferenciasService().encerrarSessao();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TelaLogin()),
      (route) => false,
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Venda de Cursos"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<SessaoModel?>(
                future: PreferenciasService().obterSessao(),
                builder: (context, snapshot) {
                  final sessao = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.school,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        sessao?.nome ?? "Cursos Online",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
            _drawerItem(
              icon: Icons.manage_accounts,
              title: "Gerenciar dados",
              onTap: () {
                Navigator.pop(context);
                _abrirGerenciamento();
              },
            ),
            Divider(),
            _drawerItem(
              icon: Icons.phone_android,
              title: "Flutter",
              onTap: () => Navigator.pop(context),
            ),
            Divider(),
            _drawerItem(
              icon: Icons.code,
              title: "Python",
              onTap: () => Navigator.pop(context),
            ),
            Divider(),
            _drawerItem(
              icon: Icons.coffee,
              title: "Java",
              onTap: () => Navigator.pop(context),
            ),
            Divider(),
            _drawerItem(
              icon: Icons.logout,
              title: "Sair",
              onTap: () {
                Navigator.pop(context);
                _sair();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CursoModel>>(
        future: _cursosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Não foi possível carregar os cursos."),
            );
          }

          final cursos = snapshot.data ?? [];
          return ListView(
            padding: EdgeInsets.all(15),
            children: [
              SizedBox(height: 10),
              _animatedItem(
                0,
                Text(
                  "Escolha um curso abaixo para começar.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              if (cursos.isEmpty)
                _animatedItem(
                  1,
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text("Nenhum curso cadastrado."),
                      ),
                    ),
                  ),
                ),
              ...cursos.asMap().entries.map(
                    (entry) => Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key == cursos.length - 1 ? 0 : 15,
                      ),
                      child: _animatedItem(
                        entry.key + 1,
                        CursoCard(
                          nomeCurso: entry.value.nome,
                          icone: entry.value.iconeData,
                          descricao: entry.value.descricao,
                          duracaoMeses: entry.value.duracaoMeses,
                          precoMensal: entry.value.precoMensal,
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}