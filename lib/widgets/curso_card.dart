import 'package:flutter/material.dart';
import '../screens/tela_compra.dart';

class CursoCard extends StatefulWidget {
  final String nomeCurso;
  final IconData icone;
  final String descricao;
  final int duracaoMeses;
  final double precoMensal;
  final bool certificadoInicial;

  CursoCard({
    required this.nomeCurso,
    required this.icone,
    required this.descricao,
    required this.duracaoMeses,
    required this.precoMensal,
    this.certificadoInicial = false,
  });

  @override
  State<CursoCard> createState() => _CursoCardState();
}

class _CursoCardState extends State<CursoCard> {
  late bool certificado;
  double _escala = 1.0;

  @override
  void initState() {
    super.initState();
    certificado = widget.certificadoInicial;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _escala,
      duration: Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: MouseRegion(
        onEnter: (_) => setState(() => _escala = 1.02),
        onExit: (_) => setState(() => _escala = 1.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.icone,
                      size: 40,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.nomeCurso,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(widget.descricao),
                SizedBox(height: 10),
                Text(
                  "Duração: ${widget.duracaoMeses} mês(es)  •  R\$ ${widget.precoMensal.toStringAsFixed(2)}/mês",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                CheckboxListTile(
                  title: Text("Adicionar certificado"),
                  value: certificado,
                  onChanged: (valor) {
                    setState(() {
                      certificado = valor!;
                    });
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
                            return TelaCompra(
                              nomeCurso: widget.nomeCurso,
                              certificado: certificado,
                              duracaoMeses: widget.duracaoMeses,
                              precoMensal: widget.precoMensal,
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
