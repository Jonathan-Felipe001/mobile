import 'package:flutter/material.dart';
import 'segunda_tela.dart';

class TelaCompra extends StatefulWidget {
  final String nomeCurso;
  final bool certificado;

  TelaCompra({
    required this.nomeCurso,
    required this.certificado,
  });

  @override
  State<TelaCompra> createState() => _TelaCompraState();
}

class _TelaCompraState extends State<TelaCompra> {
  int meses = 1;
  double precoMensal = 100;

  double calcularPreco() {
    double total = precoMensal * meses;

    if (widget.certificado) {
      total += 50;
    }

    if (meses >= 6) {
      total *= 0.9;
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
                  widget.nomeCurso,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Escolha o tempo de acesso:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (meses > 1) {
                          setState(() {
                            meses--;
                          });
                        }
                      },
                    ),
                    Text(
                      "$meses mês(es)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          meses++;
                        });
                      },
                    ),
                  ],
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
                  widget.certificado
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
                              nomeCurso: widget.nomeCurso,
                              certificado: widget.certificado,
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
