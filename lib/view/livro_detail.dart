import 'package:tde_livros/config/database_helper.dart';
import 'package:tde_livros/models/livro.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LivroDetail extends StatefulWidget {
  final String appBarTitle;
  final Livro livro;

  LivroDetail(this.livro, this.appBarTitle);
  @override
  _LivroDetailState createState() {
    return _LivroDetailState(this.livro, this.appBarTitle);
  }
}

class _LivroDetailState extends State<LivroDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Livro livro;

  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController editoraController = TextEditingController();
  //TODO; CRIAR O BOTÃO MAIS

  _LivroDetailState(this.livro, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;

    tituloController.text = livro.titulo;
    autorController.text = livro.autor;
    editoraController.text = livro.editora;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: tituloController,
                style: textStyle,
                onChanged: (value) {
                  //debugPrint('PASSOU');
                  updateTitulo();
                },
                decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // 3 elemento
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: autorController,
                style: textStyle,
                onChanged: (value) {
                  //debugPrint('PASSOU2');
                  updateAutor();
                },
                decoration: InputDecoration(
                    labelText: 'Autor',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // 4 elemento
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: editoraController,
                style: textStyle,
                onChanged: (value) {
                  //debugPrint('PASSOU2');
                  updateEditora();
                },
                decoration: InputDecoration(
                    labelText: 'Editora',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // TODO elemento do já foi lido

            // botões:
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Salvar',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Clic salvar");
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Apagar',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Apagar clicado");
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitulo() {
    livro.titulo = tituloController.text;
  }

  void updateAutor() {
    livro.autor = autorController.text;
  }

  void updateEditora() {
    livro.editora = editoraController.text;
  }

  void _save() async {
    moveToLastScreen();

    //todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (livro.id != null) {
      // Atualizar
      result = await helper.updateLivro(livro);
    } else {
      // Inserir
      result = await helper.insertLivro(livro);
    }

    if (result != 0) {
      // Sucesso
      _showAlertDialog('Status', 'Salvo com sucesso $result');
    } else {
      // deu merda
      _showAlertDialog('Status', 'Ocorreu erro');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (livro.id == null) {
      _showAlertDialog('Status', 'Não há nada a deletar');
      return;
    }
    int result;
    result = await helper.deleteLivro(livro.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Menos uma coisa a fazer!');
    } else {
      _showAlertDialog('Status', 'Deu pau!');
    }
  }

  void _showAlertDialog(String titulo, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
