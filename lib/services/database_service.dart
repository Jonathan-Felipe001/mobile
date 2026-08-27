import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../models/curso_model.dart';
import '../models/usuario_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final caminho = join(await getDatabasesPath(), 'cursos_online.db');
    _database = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL,
            criado_em TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE cursos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            descricao TEXT NOT NULL,
            duracao_meses INTEGER NOT NULL,
            preco_mensal REAL NOT NULL,
            icone TEXT NOT NULL
          )
        ''');

        await _inserirCursosIniciais(db);
      },
    );

    return _database!;
  }

  String gerarHashSenha(String senha) {
    return sha256.convert(utf8.encode(senha)).toString();
  }

  Future<void> _inserirCursosIniciais(DatabaseExecutor db) async {
    final cursos = [
      CursoModel(
        nome: 'Curso de Flutter',
        descricao: 'Aprenda a criar aplicativos Android e iOS.',
        duracaoMeses: 4,
        precoMensal: 120,
        icone: 'phone_android',
      ),
      CursoModel(
        nome: 'Curso de Python',
        descricao: 'Aprenda programação com Python.',
        duracaoMeses: 3,
        precoMensal: 100,
        icone: 'code',
      ),
      CursoModel(
        nome: 'Curso de Java',
        descricao: 'Aprenda desenvolvimento com Java.',
        duracaoMeses: 6,
        precoMensal: 150,
        icone: 'coffee',
      ),
    ];

    for (final curso in cursos) {
      await db.insert('cursos', curso.toMap());
    }
  }

  Future<int> inserirUsuario(UsuarioModel usuario) async {
    final db = await database;
    return db.insert(
      'usuarios',
      usuario.copyWithSenha(gerarHashSenha(usuario.senha)).toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<UsuarioModel?> buscarUsuarioPorEmail(String email) async {
    final db = await database;
    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );

    if (resultado.isEmpty) return null;
    return UsuarioModel.fromMap(resultado.first);
  }

  Future<UsuarioModel?> autenticarUsuario(
    String email,
    String senha,
  ) async {
    final usuario = await buscarUsuarioPorEmail(email);
    if (usuario == null || usuario.senha != gerarHashSenha(senha)) {
      return null;
    }
    return usuario;
  }

  Future<List<UsuarioModel>> listarUsuarios() async {
    final db = await database;
    final resultado = await db.query('usuarios', orderBy: 'nome ASC');
    return resultado.map(UsuarioModel.fromMap).toList();
  }

  Future<int> atualizarUsuario(
    UsuarioModel usuario, {
    String? senhaNova,
  }) async {
    final db = await database;
    final dados = usuario.toMap()..remove('id');
    if (senhaNova != null && senhaNova.isNotEmpty) {
      dados['senha'] = gerarHashSenha(senhaNova);
    } else {
      dados.remove('senha');
    }
    return db.update(
      'usuarios',
      dados,
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> removerUsuario(int id) async {
    final db = await database;
    return db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CursoModel>> listarCursos() async {
    final db = await database;
    final resultado = await db.query('cursos', orderBy: 'nome ASC');
    return resultado.map(CursoModel.fromMap).toList();
  }

  Future<int> inserirCurso(CursoModel curso) async {
    final db = await database;
    return db.insert('cursos', curso.toMap());
  }

  Future<int> atualizarCurso(CursoModel curso) async {
    final db = await database;
    final dados = curso.toMap()..remove('id');
    return db.update(
      'cursos',
      dados,
      where: 'id = ?',
      whereArgs: [curso.id],
    );
  }

  Future<int> removerCurso(int id) async {
    final db = await database;
    return db.delete('cursos', where: 'id = ?', whereArgs: [id]);
  }
}

extension on UsuarioModel {
  UsuarioModel copyWithSenha(String novaSenha) {
    return UsuarioModel(
      id: id,
      nome: nome,
      email: email,
      senha: novaSenha,
      criadoEm: criadoEm ?? DateTime.now().toIso8601String(),
    );
  }
}