import 'package:flutter/material.dart';
import '../screens/tela_compra.dart';

class CursoCard extends StatefulWidget {
  final String nomeCurso;
  final IconData icone;
  final String descricao;
  final bool certificadoInicial;

  CursoCard({
    required this.nomeCurso,
    required this.icone,
    required this.descricao,
    this.certificadoInicial = false,
  });

  @override
  State<CursoCard> createState() => _CursoCardState();
}

class _CursoCardState extends State<CursoCard> {
  late bool certificado;

  @override
  void initState() {
    super.initState();
    certificado = widget.certificadoInicial;
  }

  @override
  Widget build(BuildContext context) {
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
