import 'package:flutter/material.dart';

import '../models/curso_model.dart';
import '../models/usuario_model.dart';
import '../services/database_service.dart';

class GerenciarDados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gerenciar dados"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: "Usuários"),
              Tab(icon: Icon(Icons.school), text: "Cursos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UsuariosCrud(),
            CursosCrud(),
          ],
        ),
      ),
    );
  }
}

class UsuariosCrud extends StatefulWidget {
  @override
  State<UsuariosCrud> createState() => _UsuariosCrudState();
}

class _UsuariosCrudState extends State<UsuariosCrud> {
  late Future<List<UsuarioModel>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() {
    _usuariosFuture = DatabaseService.instance.listarUsuarios();
  }

  Future<void> _abrirFormulario({UsuarioModel? usuario}) async {
    final resultado = await showDialog<UsuarioFormularioResultado>(
      context: context,
      builder: (context) => UsuarioFormulario(usuario: usuario),
    );
    if (resultado == null) return;

    try {
      if (usuario == null) {
        await DatabaseService.instance.inserirUsuario(
          UsuarioModel(
            nome: resultado.nome,
            email: resultado.email,
            senha: resultado.senha,
          ),
        );
      } else {
        await DatabaseService.instance.atualizarUsuario(
          UsuarioModel(
            id: usuario.id,
            nome: resultado.nome,
            email: resultado.email,
            senha: '',
            criadoEm: usuario.criadoEm,
          ),
          senhaNova: resultado.senha,
        );
      }
      if (!mounted) return;
      setState(_atualizarLista);
      _mostrarMensagem("Usuário salvo com sucesso.", Colors.green);
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem("Não foi possível salvar. O e-mail pode já existir.", Colors.red);
    }
  }

  Future<void> _remover(UsuarioModel usuario) async {
    final confirmou = await _confirmarExclusao(
      "Excluir usuário?",
      "A conta de ${usuario.nome} será removida do banco local.",
    );
    if (!confirmou || usuario.id == null) return;

    await DatabaseService.instance.removerUsuario(usuario.id!);
    if (!mounted) return;
    setState(_atualizarLista);
    _mostrarMensagem("Usuário removido.", Colors.green);
  }

  Future<bool> _confirmarExclusao(String titulo, String mensagem) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir"),
          ),
        ],
      ),
    );
    return resultado ?? false;
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UsuarioModel>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Não foi possível carregar os usuários."));
          }

          final usuarios = snapshot.data ?? [];
          if (usuarios.isEmpty) {
            return Center(child: Text("Nenhum usuário cadastrado."));
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: usuarios.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      usuario.nome.isEmpty ? "?" : usuario.nome[0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(usuario.nome),
                  subtitle: Text(usuario.email),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: "Editar",
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _abrirFormulario(usuario: usuario),
                      ),
                      IconButton(
                        tooltip: "Excluir",
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _remover(usuario),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: Icon(Icons.add),
        tooltip: "Adicionar usuário",
      ),
    );
  }
}

class CursosCrud extends StatefulWidget {
  @override
  State<CursosCrud> createState() => _CursosCrudState();
}

class _CursosCrudState extends State<CursosCrud> {
  late Future<List<CursoModel>> _cursosFuture;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() {
    _cursosFuture = DatabaseService.instance.listarCursos();
  }

  Future<void> _abrirFormulario({CursoModel? curso}) async {
    final resultado = await showDialog<CursoFormularioResultado>(
      context: context,
      builder: (context) => CursoFormulario(curso: curso),
    );
    if (resultado == null) return;

    final dados = CursoModel(
      id: curso?.id,
      nome: resultado.nome,
      descricao: resultado.descricao,
      duracaoMeses: resultado.duracaoMeses,
      precoMensal: resultado.precoMensal,
      icone: resultado.icone,
    );

    if (curso == null) {
      await DatabaseService.instance.inserirCurso(dados);
    } else {
      await DatabaseService.instance.atualizarCurso(dados);
    }
    if (!mounted) return;
    setState(_atualizarLista);
    _mostrarMensagem("Curso salvo com sucesso.", Colors.green);
  }

  Future<void> _remover(CursoModel curso) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Excluir curso?"),
        content: Text("O curso ${curso.nome} será removido do banco local."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir"),
          ),
        ],
      ),
    );
    if (confirmou != true || curso.id == null) return;

    await DatabaseService.instance.removerCurso(curso.id!);
    if (!mounted) return;
    setState(_atualizarLista);
    _mostrarMensagem("Curso removido.", Colors.green);
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CursoModel>>(
        future: _cursosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Não foi possível carregar os cursos."));
          }

          final cursos = snapshot.data ?? [];
          if (cursos.isEmpty) {
            return Center(child: Text("Nenhum curso cadastrado."));
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: cursos.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final curso = cursos[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    curso.iconeData,
                    color: Colors.blue,
                    size: 34,
                  ),
                  title: Text(curso.nome),
                  subtitle: Text(
                    "${curso.duracaoMeses} meses • R\$ ${curso.precoMensal.toStringAsFixed(2)}/mês",
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: "Editar",
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _abrirFormulario(curso: curso),
                      ),
                      IconButton(
                        tooltip: "Excluir",
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _remover(curso),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: Icon(Icons.add),
        tooltip: "Adicionar curso",
      ),
    );
  }
}

class UsuarioFormularioResultado {
  final String nome;
  final String email;
  final String senha;

  const UsuarioFormularioResultado({
    required this.nome,
    required this.email,
    required this.senha,
  });
}

class UsuarioFormulario extends StatefulWidget {
  final UsuarioModel? usuario;

  const UsuarioFormulario({this.usuario});

  @override
  State<UsuarioFormulario> createState() => _UsuarioFormularioState();
}

class _UsuarioFormularioState extends State<UsuarioFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _email;
  final _senha = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: widget.usuario?.nome);
    _email = TextEditingController(text: widget.usuario?.email);
  }

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.usuario != null;
    return AlertDialog(
      title: Text(editando ? "Editar usuário" : "Novo usuário"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nome,
                decoration: InputDecoration(labelText: "Nome completo"),
                validator: (valor) =>
                    valor == null || valor.trim().isEmpty ? "Obrigatório" : null,
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "E-mail"),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) return "Obrigatório";
                  if (!valor.contains("@")) return "E-mail inválido";
                  return null;
                },
              ),
              TextFormField(
                controller: _senha,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: editando ? "Nova senha (opcional)" : "Senha",
                ),
                validator: (valor) {
                  if (!editando && (valor == null || valor.isEmpty)) {
                    return "Obrigatório";
                  }
                  if (valor != null && valor.isNotEmpty && valor.length < 6) {
                    return "Mínimo de 6 caracteres";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              UsuarioFormularioResultado(
                nome: _nome.text.trim(),
                email: _email.text.trim().toLowerCase(),
                senha: _senha.text,
              ),
            );
          },
          child: Text("Salvar"),
        ),
      ],
    );
  }
}

class CursoFormularioResultado {
  final String nome;
  final String descricao;
  final int duracaoMeses;
  final double precoMensal;
  final String icone;

  const CursoFormularioResultado({
    required this.nome,
    required this.descricao,
    required this.duracaoMeses,
    required this.precoMensal,
    required this.icone,
  });
}

class CursoFormulario extends StatefulWidget {
  final CursoModel? curso;

  const CursoFormulario({this.curso});

  @override
  State<CursoFormulario> createState() => _CursoFormularioState();
}

class _CursoFormularioState extends State<CursoFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _descricao;
  late final TextEditingController _duracao;
  late final TextEditingController _preco;
  String _icone = "phone_android";

  @override
  void initState() {
    super.initState();
    final curso = widget.curso;
    _nome = TextEditingController(text: curso?.nome);
    _descricao = TextEditingController(text: curso?.descricao);
    _duracao = TextEditingController(text: curso?.duracaoMeses.toString());
    _preco = TextEditingController(text: curso?.precoMensal.toString());
    _icone = curso?.icone ?? "phone_android";
  }

  @override
  void dispose() {
    _nome.dispose();
    _descricao.dispose();
    _duracao.dispose();
    _preco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.curso == null ? "Novo curso" : "Editar curso"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nome,
                decoration: InputDecoration(labelText: "Nome do curso"),
                validator: (valor) =>
                    valor == null || valor.trim().isEmpty ? "Obrigatório" : null,
              ),
              TextFormField(
                controller: _descricao,
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (valor) =>
                    valor == null || valor.trim().isEmpty ? "Obrigatório" : null,
              ),
              TextFormField(
                controller: _duracao,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Duração (meses)"),
                validator: (valor) {
                  final numero = int.tryParse(valor ?? "");
                  if (numero == null || numero <= 0) return "Informe um número válido";
                  return null;
                },
              ),
              TextFormField(
                controller: _preco,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Preço mensal"),
                validator: (valor) {
                  final numero = double.tryParse((valor ?? "").replaceAll(",", "."));
                  if (numero == null || numero <= 0) return "Informe um preço válido";
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _icone,
                decoration: InputDecoration(labelText: "Ícone"),
                items: [
                  DropdownMenuItem(
                    value: "phone_android",
                    child: Text("Celular"),
                  ),
                  DropdownMenuItem(
                    value: "code",
                    child: Text("Código"),
                  ),
                  DropdownMenuItem(
                    value: "coffee",
                    child: Text("Java"),
                  ),
                ],
                onChanged: (valor) {
                  if (valor != null) setState(() => _icone = valor);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              CursoFormularioResultado(
                nome: _nome.text.trim(),
                descricao: _descricao.text.trim(),
                duracaoMeses: int.parse(_duracao.text),
                precoMensal: double.parse(_preco.text.replaceAll(",", ".")),
                icone: _icone,
              ),
            );
          },
          child: Text("Salvar"),
        ),
      ],
    );
  }
}