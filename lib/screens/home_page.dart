import 'package:flutter/material.dart';
import '../widgets/curso_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Venda de Cursos"),
        backgroundColor: Colors.blue,
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
          Text(
            "Escolha um curso abaixo para começar.",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          CursoCard(
            nomeCurso: "Curso de Flutter",
            icone: Icons.phone_android,
            descricao: "Aprenda a criar aplicativos Android e iOS.",
            duracaoMeses: 4,
            precoMensal: 120,
          ),
          SizedBox(height: 15),
          CursoCard(
            nomeCurso: "Curso de Python",
            icone: Icons.code,
            descricao: "Aprenda programação com Python.",
            duracaoMeses: 3,
            precoMensal: 100,
          ),
          SizedBox(height: 15),
          CursoCard(
            nomeCurso: "Curso de Java",
            icone: Icons.coffee,
            descricao: "Aprenda desenvolvimento com Java.",
            duracaoMeses: 6,
            precoMensal: 150,
          ),
        ],
      ),
    );
  }
}
