import 'package:flutter/material.dart';
import 'segunda_tela.dart';

class TelaCompra extends StatelessWidget {
  final String nomeCurso;
  final bool certificado;
  final int duracaoMeses;
  final double precoMensal;

  TelaCompra({
    required this.nomeCurso,
    required this.certificado,
    required this.duracaoMeses,
    required this.precoMensal,
  });

  double calcularPreco() {
    double total = precoMensal * duracaoMeses;

    if (certificado) {
      total += 50;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Finalizar Compra"),
        backgroundColor: Colors.blue,
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
                  Icons.shopping_cart,
                  color: Colors.blue,
                  size: 80,
                ),
                SizedBox(height: 15),
                Text(
                  nomeCurso,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Duração do curso: $duracaoMeses mês(es)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Mensalidade: R\$ ${precoMensal.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0,
                    end: calcularPreco(),
                  ),
                  duration: Duration(seconds: 1),
                  builder: (context, valor, child) {
                    return Text(
                      "Total: R\$ ${valor.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  certificado
                      ? "Certificado incluso (+R\$50)"
                      : "Sem certificado",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Confirmar Compra"),
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
        ),
      ),
    );
  }
}