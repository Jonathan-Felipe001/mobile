class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? criadoEm;

  const UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.criadoEm,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email.trim().toLowerCase(),
      'senha': senha,
      'criado_em': criadoEm,
    };
  }

  factory UsuarioModel.fromMap(Map<String, Object?> map) {
    return UsuarioModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      criadoEm: map['criado_em'] as String?,
    );
  }
}