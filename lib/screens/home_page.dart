import 'package:flutter/material.dart';
import '../widgets/curso_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    final inicio = (index * 0.15).clamp(0.0, 1.0);
    final fim = (inicio + 0.6).clamp(0.0, 1.0);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Venda de Cursos"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  "Cursos Online",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text("Flutter"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.code),
              title: Text("Python"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.coffee),
              title: Text("Java"),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          SizedBox(height: 10),
          _animatedItem(
            0,
            Text(
              "Escolha um curso abaixo para começar.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
          _animatedItem(
            1,
            CursoCard(
              nomeCurso: "Curso de Flutter",
              icone: Icons.phone_android,
              descricao: "Aprenda a criar aplicativos Android e iOS.",
              duracaoMeses: 4,
              precoMensal: 120,
            ),
          ),
          SizedBox(height: 15),
          _animatedItem(
            2,
            CursoCard(
              nomeCurso: "Curso de Python",
              icone: Icons.code,
              descricao: "Aprenda programação com Python.",
              duracaoMeses: 3,
              precoMensal: 100,
            ),
          ),
          SizedBox(height: 15),
          _animatedItem(
            3,
            CursoCard(
              nomeCurso: "Curso de Java",
              icone: Icons.coffee,
              descricao: "Aprenda desenvolvimento com Java.",
              duracaoMeses: 6,
              precoMensal: 150,
            ),
          ),
        ],
      ),
    );
  }
}
