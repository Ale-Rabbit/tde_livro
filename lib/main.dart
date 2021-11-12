import 'package:flutter/material.dart';

import 'view/livro_list.dart';

void main() {
  runApp(AppLivro());
}

class AppLivro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livro Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: LivroList(), //const MyHomePage(title: 'Manutenção de livros')
    );
  }
}
