import 'package:flutter/material.dart';
import 'segunda_tela.dart';

class TelaFormulario extends StatefulWidget {
  final String nomeCurso;
  final bool certificado;

  TelaFormulario({
    required this.nomeCurso,
    required this.certificado,
  });

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  String formaPagamento = "Cartão de Crédito";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Dados da Compra"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 500),
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
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        color: Colors.blue,
                        size: 32,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.nomeCurso,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Dados pessoais",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nome completo",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "CPF",
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Telefone",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Endereço",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "CEP",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Endereço completo",
                      prefixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Forma de pagamento",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 5),

                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Cartão de Crédito"),
                    value: "Cartão de Crédito",
                    groupValue: formaPagamento,
                    onChanged: (valor) {
                      setState(() {
                        formaPagamento = valor.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Boleto"),
                    value: "Boleto",
                    groupValue: formaPagamento,
                    onChanged: (valor) {
                      setState(() {
                        formaPagamento = valor.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Pix"),
                    value: "Pix",
                    groupValue: formaPagamento,
                    onChanged: (valor) {
                      setState(() {
                        formaPagamento = valor.toString();
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Número do cartão (se aplicável)",
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Finalizar Compra"),
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
      ),
    );
  }
}
