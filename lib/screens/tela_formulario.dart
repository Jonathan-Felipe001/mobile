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
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cartaoController = TextEditingController();
  String formaPagamento = "Cartão de Crédito";

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _enderecoController.dispose();
    _cartaoController.dispose();
    super.dispose();
  }

  String? _campoObrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return "Informe $campo";
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return "Informe seu e-mail";
    }
    if (!valor.contains("@") || !valor.contains(".")) {
      return "Informe um e-mail válido";
    }
    return null;
  }

  void _finalizarCompra() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Preencha todos os campos obrigatórios para continuar."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados da Compra"),
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
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
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

                  TextFormField(
                    controller: _nomeController,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "seu nome completo"),
                    decoration: InputDecoration(
                      labelText: "Nome completo",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validarEmail,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    validator: (valor) => _campoObrigatorio(valor, "seu CPF"),
                    decoration: InputDecoration(
                      labelText: "CPF",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "seu telefone"),
                    decoration: InputDecoration(
                      labelText: "Telefone",
                      suffixText: "*",
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

                  TextFormField(
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    validator: (valor) => _campoObrigatorio(valor, "seu CEP"),
                    decoration: InputDecoration(
                      labelText: "CEP",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _enderecoController,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "seu endereço completo"),
                    decoration: InputDecoration(
                      labelText: "Endereço completo",
                      suffixText: "*",
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

                  TextFormField(
                    controller: _cartaoController,
                    keyboardType: TextInputType.number,
                    validator: formaPagamento == "Cartão de Crédito"
                        ? (valor) =>
                            _campoObrigatorio(valor, "o número do cartão")
                        : null,
                    decoration: InputDecoration(
                      labelText: formaPagamento == "Cartão de Crédito"
                          ? "Número do cartão"
                          : "Número do cartão (opcional)",
                      suffixText:
                          formaPagamento == "Cartão de Crédito" ? "*" : null,
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Finalizar Compra"),
                      onPressed: _finalizarCompra,
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