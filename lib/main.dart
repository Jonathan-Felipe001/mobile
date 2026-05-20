import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Venda de Cursos",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Venda de Cursos"),
      ),

      drawer: Drawer(
        child: Column(
          children: [

            DrawerHeader(
              child: Text(
                "Cursos Online",
                style: TextStyle(fontSize: 25),
              ),
            ),

            Text("Flutter"),
            Divider(),
            Text("Python"),
            Divider(),
            Text("Java"),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            cursoCard(
              context,
              "Curso de Flutter",
            ),

            SizedBox(height: 20),

            cursoCard(
              context,
              "Curso de Python",
            ),

            SizedBox(height: 20),

            cursoCard(
              context,
              "Curso de Java",
            ),
          ],
        ),
      ),
    );
  }

  Widget cursoCard(BuildContext context, String nomeCurso) {

    bool certificado = false;

    return Card(
      elevation: 5,

      child: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            Text(
              nomeCurso,
              style: TextStyle(fontSize: 22),
            ),

            SizedBox(height: 10),

            StatefulBuilder(
              builder: (context, setState) {

                return CheckboxListTile(
                  title: Text("Adicionar certificado"),
                  value: certificado,

                  onChanged: (v) {
                    setState(() {
                      certificado = v!;
                    });
                  },
                );
              },
            ),

            ElevatedButton(
              child: Text("Comprar Curso"),

              onPressed: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) {

                      return SegundaTela(
                        nomeCurso: nomeCurso,
                        certificado: certificado,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {

  final String nomeCurso;
  final bool certificado;

  SegundaTela({
    required this.nomeCurso,
    required this.certificado,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Resumo"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Compra realizada!",
              style: TextStyle(fontSize: 25),
            ),

            SizedBox(height: 20),

            Text(
              nomeCurso,
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 20),

            Text(
              certificado
                  ? "Com certificado"
                  : "Sem certificado",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Voltar"),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}