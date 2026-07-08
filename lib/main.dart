import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Venda de Cursos",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: Text("Venda de Cursos"),
        backgroundColor: Colors.blue,
      ),

      drawer: Drawer(
        child: ListView(
          children: [

            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),

              child: Center(
                child: Text(
                  "Cursos Online",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),),),),

            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text("Flutter"),
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.code),
              title: Text("Python"),
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.coffee),
              title: Text("Java"),
            ),

          ],),),

      body: ListView(
        padding: EdgeInsets.all(15),

        children: [
          SizedBox(height: 10),

          Text(
            "Escolha um curso abaixo para começar.",
            style: TextStyle(
              fontSize: 16,
            ),),

          SizedBox(height: 20),

          cursoCard(
            context,
            "Curso de Flutter",
            Icons.phone_android,
            "Aprenda a criar aplicativos Android e iOS.",
            false
          ),

          SizedBox(height: 15),

          cursoCard(
            context,
            "Curso de Python",
            Icons.code,
            "Aprenda programação com Python.",
            false
          ),

          SizedBox(height: 15),

          cursoCard(
            context,
            "Curso de Java",
            Icons.coffee,
            "Aprenda desenvolvimento com Java.",
            false
          ),],),);}

  Widget cursoCard(
    BuildContext context,
    String nomeCurso,
    IconData icone,
    String descricao,
    bool certificado,
  ) {

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
                  icone,
                  size: 40,
                  color: Colors.blue,
                ),

                SizedBox(width: 10),

                Text(
                  nomeCurso,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
),),],),

            SizedBox(height: 10),

            Text(descricao),

            SizedBox(height: 10),

            StatefulBuilder(
              builder: (context, setState) {
                return CheckboxListTile(
                  title: Text("Adicionar certificado"),
                  value: certificado,

                  onChanged: (valor) {
                    setState(() {
                      certificado = valor!;
                    });
                  },
                );
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
                          nomeCurso: nomeCurso,
                          certificado: certificado,
);},),);},),),],),),);}}

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
                  ),),

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
),);},),

                SizedBox(height: 10),

                Text(
                  widget.certificado
                      ? "Certificado incluso (+R\$50)"
                      : "Sem certificado",

                  style: TextStyle(
                    fontSize: 16,
                  ),),

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
);},),);},),),],),),),),);}}

class SegundaTela extends StatelessWidget {

  final String nomeCurso;
  final bool certificado;

  SegundaTela({
    required this.nomeCurso,
    required this.certificado,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Resumo"),
        backgroundColor: Colors.blue,
      ),

      backgroundColor: Colors.grey[200],

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
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),

                SizedBox(height: 15),

                Text(
                  "Compra realizada!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),),

                SizedBox(height: 20),

                Text(
                  nomeCurso,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  certificado
                      ? "Certificado incluído."
                      : "Sem certificado.",

                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  child: Text("Voltar"),

                  onPressed: () {
                    Navigator.pop(context);
},),],),),),),);}}