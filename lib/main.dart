import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Venda de Cursos",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

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
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 20),

          cursoCard(
            context,
            "Curso de Flutter",
            Icons.phone_android,
            "Aprenda a criar aplicativos Android e iOS.",
          ),

          SizedBox(height: 15),

          cursoCard(
            context,
            "Curso de Python",
            Icons.code,
            "Aprenda programação com Python.",
          ),

          SizedBox(height: 15),

          cursoCard(
            context,
            "Curso de Java",
            Icons.coffee,
            "Aprenda desenvolvimento com Java.",
          ),

        ],
      ),
    );
  }

  Widget cursoCard(
      BuildContext context,
      String nomeCurso,
      IconData icone,
      String descricao,
      ) {

    bool certificado = false;

    return Card(
      elevation: 5,

      child: Padding(
        padding: EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Icon(
                  icone,
                  size: 40,
                  color: Colors.blue,
                ),

                SizedBox(width: 10),

                Text(
                  nomeCurso,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            SizedBox(height: 10),

            Text(descricao),

            SizedBox(height: 10),

            StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  title: Text("Adicionar certificado"),
                  value: certificado,

                  onChanged: (valor) {
                    setState(() {
                      certificado = valor!;
                    });
                  },
                );
              },
            ),

            SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
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
        child: Card(
          elevation: 5,

          margin: EdgeInsets.all(20),

          child: Padding(
            padding: EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),

                SizedBox(height: 15),

                Text(
                  "Compra realizada!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  nomeCurso,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  certificado
                      ? "Certificado incluído."
                      : "Sem certificado.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  child: Text("Voltar"),

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}