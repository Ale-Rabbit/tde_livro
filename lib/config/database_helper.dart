import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tde_livros/models/livro.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String livroTable = 'livro_table';
  String colId = 'id';
  String colTitulo = 'titulo';
  String colAutor = 'autor';
  String colEditora = 'editora';
  String colJaFoiLido = 'ja_foi_lido';

  DatabaseHelper._createInstancia();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstancia();
    }
    return _databaseHelper;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'Create table $livroTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitulo TEXT, '
        '$colAutor TEXT, $colEditora Text, $colJaFoiLido Text)');
  }

  Future<Database> initializeDatabase() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String path = diretorio.path + "livro.db";
    var livroDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return livroDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //INSERT
  Future<int> insertLivro(Livro livro) async {
    Database db = await this.database;
    var result = db.insert(livroTable, livro.toMap());
    return result;
  }

  Future<List<Livro>> getLivroList() async {
    var livroMapList = await getLivroMapList();
    int count = livroMapList.length;
    List<Livro> livroList = List<Livro>();

    for (int i = 0; i < count; i++) {
      livroList.add(Livro.fromMapObject(livroMapList[i]));
    }

    return livroList;
  }

  //seleção maps
  Future<List<Map<String, dynamic>>> getLivroMapList() async {
    Database db = await this.database;
    var result = await db.query(livroTable, orderBy: '$colTitulo ASC');
    return result;
  }

  //DELETE
  Future<int> deleteLivro(int id) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $livroTable WHERE $colId=$id');
    return result;
  }

  //UPDATE
  Future<int> updateLivro(Livro livro) async {
    Database db = await this.database;
    var result = db.update(livroTable, livro.toMap(),
        where: '$colId =?', whereArgs: [livro.id]);
    return result;
  }
}
