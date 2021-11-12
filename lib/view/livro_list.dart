import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tde_livros/config/database_helper.dart';
import 'package:tde_livros/models/livro.dart';

import 'livro_detail.dart';

class LivroList extends StatefulWidget {
  @override
  _LivroListState createState() => _LivroListState();
}

class _LivroListState extends State<LivroList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Livro> livroList = <Livro>[]; //List<Livro>();

  @override
  void initState() {
    super.initState();
    updateListView();
    debugPrint(livroList.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text('DEU CERTOOOO'),
          ),
      body: getTodosListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //debugPrint('Clicl');
          navigateToDetail(Livro('', '', '', true), 'Adicionar');
        },
        tooltip: '+ 1 A fazer',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getTodosListView() {
    return ListView.builder(
      itemCount: livroList.length,
      itemBuilder: (BuildContext context, int position) {
        Livro livro = livroList[position];

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(getAvatar(livro.titulo),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(livro.titulo,
                style: TextStyle(fontWeight: FontWeight.bold)),
            //subtitle: Text(livro.desc),
            trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.blueAccent,
                ),
                onTap: () {
                  _delete(context, livro);
                }),
            onTap: () {
              print("Lista detalhes");
              navigateToDetail(livro, livro.titulo);

              //faça o navigate
            },
          ),
        );
      },
    );
  }

  getAvatar(String titulo) {
    if (titulo.length < 2) {
      return '';
    } else {
      return titulo.substring(0, 2);
    }
  }

  void navigateToDetail(Livro livro, String titulo) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LivroDetail(livro, titulo);
      //debugPrint("Chamou a segunda tela");
    })).then((result) {
      if (result ?? true) {
        updateListView();
      }
    });
  }

  void _delete(BuildContext ctx, Livro livro) async {
    int result = await databaseHelper.deleteLivro(livro.id);
    if (result != 0) {
      _showSnackBar(ctx, "Deletando...");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Livro>> livroListFuture = databaseHelper.getLivroList();
      livroListFuture.then((livroList) {
        setState(() {
          this.livroList = livroList;
        });
      });
    });
  }
}
