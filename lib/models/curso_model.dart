import 'package:flutter/material.dart';

class CursoModel {
  final int? id;
  final String nome;
  final String descricao;
  final int duracaoMeses;
  final double precoMensal;
  final String icone;

  const CursoModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.duracaoMeses,
    required this.precoMensal,
    required this.icone,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'duracao_meses': duracaoMeses,
      'preco_mensal': precoMensal,
      'icone': icone,
    };
  }

  factory CursoModel.fromMap(Map<String, Object?> map) {
    return CursoModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
      duracaoMeses: map['duracao_meses'] as int,
      precoMensal: (map['preco_mensal'] as num).toDouble(),
      icone: map['icone'] as String,
    );
  }

  IconData get iconeData {
    switch (icone) {
      case 'code':
        return Icons.code;
      case 'coffee':
        return Icons.coffee;
      case 'phone_android':
      default:
        return Icons.phone_android;
    }
  }
}