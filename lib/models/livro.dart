class Livro {
  int _id;
  String _titulo;
  String _autor;
  String _editora;
  bool _jaFoiLido;

  Livro(this._titulo, this._autor, this._editora,
      this._jaFoiLido); // construtor do objeto
  Livro.comId(this._id, this._titulo, this._autor, this._editora,
      this._jaFoiLido); //construtor nomeado

  int get id => _id;
  String get titulo => _titulo;
  String get autor => _autor;
  String get editora => _editora;
  bool get jaFoiLido => _jaFoiLido;

  set titulo(String novoTitulo) {
    if (novoTitulo.length <= 255) {
      this._titulo = novoTitulo;
    }
  }

  set autor(String novoAautor) {
    if (novoAautor.length <= 255) {
      this._autor = novoAautor;
    }
  }

  set editora(String novaEditora) {
    if (novaEditora.length <= 255) {
      this._editora = novaEditora;
    }
  }

  set jaFoiLido(bool novaFlag) {
    this._jaFoiLido = novaFlag;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['titulo'] = _titulo;
    map['autor'] = _autor;
    map['editora'] = _editora;
    map['jaFoiLido'] = _jaFoiLido;

    return map;
  }

  Livro.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._titulo = map['titulo'];
    this._autor = map['autor'];
    this._editora = map['editora'];
    // TODO: jaFoiLido
  }
}
