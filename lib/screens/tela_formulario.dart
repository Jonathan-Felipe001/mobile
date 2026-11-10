import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/viacep_service.dart';
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
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cartaoController = TextEditingController();
  final _viaCepService = ViaCepService();
  String? _erroCep;
  String? _ultimoCepConsultado;
  bool _consultandoCep = false;
  String formaPagamento = "Cartão de Crédito";

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _cartaoController.dispose();
    super.dispose();
  }

  Future<void> _consultarCep(String valor) async {
    final cep = valor.replaceAll(RegExp(r'\D'), '');

    if (cep.length < 8) {
      if (_ultimoCepConsultado != null ||
          _erroCep != null ||
          _consultandoCep) {
        setState(() {
          _ultimoCepConsultado = null;
          _erroCep = null;
          _consultandoCep = false;
        });
      }
      return;
    }

    if (cep.length != 8 || cep == _ultimoCepConsultado) return;

    _ultimoCepConsultado = cep;
    setState(() {
      _erroCep = null;
      _consultandoCep = true;
    });

    try {
      final endereco = await _viaCepService.consultarCep(cep);
      if (!mounted || _cepController.text.replaceAll(RegExp(r'\D'), '') != cep) {
        return;
      }

      setState(() {
        _consultandoCep = false;
        if (endereco == null) {
          _erroCep = 'CEP não encontrado.';
          return;
        }
        _erroCep = null;
        _ruaController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
      });
    } catch (_) {
      if (!mounted || _cepController.text.replaceAll(RegExp(r'\D'), '') != cep) {
        return;
      }
      setState(() {
        _consultandoCep = false;
        _erroCep = 'Não foi possível consultar o CEP. Verifique sua conexão.';
      });
    }
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    onChanged: _consultarCep,
                    validator: (valor) {
                      final cep = valor?.replaceAll(RegExp(r'\D'), '') ?? '';
                      if (cep.isEmpty) return "Informe seu CEP";
                      if (cep.length != 8) return "Informe um CEP com 8 dígitos";
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "CEP",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.location_on),
                      suffixIcon: _consultandoCep
                          ? Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                      errorText: _erroCep,
                      helperText: "Rua, bairro e cidade serão preenchidos automaticamente.",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _ruaController,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "sua rua"),
                    decoration: InputDecoration(
                      labelText: "Rua",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.signpost),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _bairroController,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "seu bairro"),
                    decoration: InputDecoration(
                      labelText: "Bairro",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _cidadeController,
                    validator: (valor) =>
                        _campoObrigatorio(valor, "sua cidade"),
                    decoration: InputDecoration(
                      labelText: "Cidade",
                      suffixText: "*",
                      prefixIcon: Icon(Icons.apartment),
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