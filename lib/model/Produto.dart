class Produto{
  int _id_item = 0;
  String _descricao = "";
  num _valor = 0;

  Produto(this._id_item, this._descricao, this._valor);

  int get id_item => _id_item;

  set id_item(int value) {
    _id_item = value;
  }

  String get descricao => _descricao;

  num get valor => _valor;

  set valor(num value) {
    _valor = value;
  }

  set descricao(String value) {
    _descricao = value;
  }
}