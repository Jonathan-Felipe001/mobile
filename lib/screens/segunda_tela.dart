import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[200],
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
