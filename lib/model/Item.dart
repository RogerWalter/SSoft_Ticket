class Item{
  int _id = 0;
  int _id_pedido = 0;
  int _id_item = 0;
  String _descricao = "";
  num _valor = 0;
  int _qtd = 0;
  String _data = "";

  Item();

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get id_item => _id_item;

  int get qtd => _qtd;

  set qtd(int value) {
    _qtd = value;
  }

  num get valor => _valor;

  set valor(num value) {
    _valor = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  set id_item(int value) {
    _id_item = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  int get id_pedido => _id_pedido;

  set id_pedido(int value) {
    _id_pedido = value;
  }
}