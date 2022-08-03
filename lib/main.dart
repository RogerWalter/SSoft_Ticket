import 'dart:io';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssoft_ticket/model/Item.dart';
import 'package:ssoft_ticket/model/Produto.dart';
import 'package:intl/intl.dart';
import 'package:ssoft_ticket/util/impressao.dart';
import 'package:window_size/window_size.dart';
import 'util/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as dr;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Sandra Foods Tickets');
    setWindowMaxSize(const Size(3000, 3000));
    setWindowMinSize(const Size(1280, 720));
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Provider<AppDatabase>(
        create: (context) => AppDatabase(),
        child: Home(),
        dispose: (context, db) => db.close(),
      ),
    )
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppDatabase appDatabase;
  List<Produto> _lista_produtos = [];
  ScrollController _scrollController = ScrollController();
  List<Item> _lista_itens = [];
  int _indice_deletar = 0;
  TextEditingController _controllerImpressora = TextEditingController();
  int _id_ult_ped = 0;
  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    _lista_produtos = _popular_lista();
    recebe_id_inserir();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Emissor de Tickets"),
        actions: <Widget>[IconButton(onPressed: ()=> _mostrar_dialogo_parametros(), icon: Icon(Icons.settings, color: Colors.white,))],
      ),
      body: Container(
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child:Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(64, 4, 64, 4),
                        child: AutoSizeText(
                          "Cardápio:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 2,
                          wrapWords: false,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.black,
                        width: 5
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 5,
                    runSpacing: 5,
                    runAlignment: WrapAlignment.center,
                    children: <Widget>[
                      for(int i=0; i<_lista_produtos.length; i++)
                        InkWell(
                          splashColor: Colors.white,
                          onTap: (){
                            Produto selecionado = _lista_produtos[i];
                            Item adicionar = Item();
                            adicionar.id_item = selecionado.id_item;
                            adicionar.descricao = selecionado.descricao;
                            adicionar.valor = selecionado.valor;
                            adicionar.qtd = 1;
                            _inserir_item_lista(adicionar);
                            setState(() {

                            });
                          },
                          child: Card(
                            elevation: 5,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                width: 120,
                                height: 120,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    AutoSizeText(
                                      _lista_produtos[i].descricao.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500
                                      ),
                                      maxLines: 2,
                                      wrapWords: false,
                                      minFontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AutoSizeText(
                                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_produtos[i].valor),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                )
                            ),
                          )
                        ),
                    ],
                  )
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child:Container(
                      child: Padding(
                      padding: EdgeInsets.fromLTRB(64, 4, 64, 4),
                      child: AutoSizeText(
                        "Itens do Pedido:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500
                        ),
                        maxLines: 2,
                        wrapWords: false,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ),
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(64, 4, 64, 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: Colors.black,
                            width: 5
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: Colors.black.withOpacity(0.20),
                              child:ListView.builder(
                                controller: _scrollController,
                                itemCount: _lista_itens.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.fromLTRB(4, 4, 4, 48),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext, index){
                                  return Container(
                                      height: 50,
                                      child: Card(
                                        child: ListTile(
                                          leading:  Container(
                                            height: 25,
                                            width: 25,
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                Icons.check, color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          title: Stack(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                                  child: Text(
                                                    _lista_itens[index].descricao,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: (20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                  child: Text(
                                                    _lista_itens[index].qtd.toString() + " x " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_itens[index].valor),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: (20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 4),
                                                  child: Text(
                                                    "Total: " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_itens[index].valor * _lista_itens[index].qtd),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: (20),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          trailing: IconButton(
                                            onPressed: ()
                                            {
                                              _indice_deletar = index;
                                              _deletar_item();
                                            },
                                            alignment: Alignment.bottomCenter,
                                            icon: Icon(Icons.delete_forever, color: Colors.red,),
                                          ),
                                        ),
                                      )
                                  );
                                },
                              ),
                            )
                        ),
                      )
                    )
                ),
                Container(
                    height: 60,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(64, 2, 64, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Container(
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        _confirmar_pedido();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        primary: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: AutoSizeText(
                                        "Confirmar",textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 24, color: Colors.white),
                                        maxLines: 1,
                                        minFontSize: 8,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  ),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Container(
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        _limpar_lista();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: AutoSizeText(
                                        "Cancelar",textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 24, color: Colors.white),
                                        maxLines: 1,
                                        minFontSize: 8,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  ),
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Container(
                                    height: 50,
                                    child: AutoSizeText(
                                      "Total: " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(_calcular_total()),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 42, color: Colors.black, fontWeight: FontWeight.w900),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                )
                            )
                          ],
                        )
                    )
                ),
              ],
            );
          }),
        )
      );
  }

  num _calcular_total(){
    num _total = 0;
    if(_lista_itens.length > 0){
      for(int i = 0; i < _lista_itens.length; i++)
        {
          num _parcial = 0;
          _parcial = _lista_itens[i].qtd * _lista_itens[i].valor;
          _total = _total + _parcial;
        }
    }
    return _total;
  }

  _inserir_item_lista(Item item){
    Item busca = Item();
    if(_lista_itens.length > 0){
      busca = _lista_itens.firstWhere((element) => item.id_item == element.id_item, orElse: () => busca);
      if(busca.id_item != 0)//item já existe na lista, somamos as quantidades
      {
        int _indice_atualizar = _lista_itens.indexOf(busca);
        int _nova_qtd = busca.qtd + item.qtd;
        item.qtd = _nova_qtd;
        _lista_itens[_indice_atualizar] = item;
      }
      else
      {
        _lista_itens.add(item);
      }
    }
    else
    {
      _lista_itens.add(item);
    }
  }

  _deletar_item()
  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Remover Item'),
            content: const Text('Deseja realmente remover este item?'),
            actions: [
              TextButton(
                  onPressed: () {
                    _lista_itens.removeAt(_indice_deletar);
                    setState(() {

                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'))
            ],
          );
        });
  }

  _limpar_lista()
  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Cancelar Pedido?'),
            content: const Text('Deseja realmente cancelar este pedido?'),
            actions: [
              TextButton(
                  onPressed: () {
                    _lista_itens.clear();
                    setState(() {

                    });
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'))
            ],
          );
        });
  }

  _mostrar_dialogo_parametros() async
  {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("impressora") != null && prefs.getString("impressora") != "")
    {
      String _impressora_recuperada = prefs.getString("impressora").toString();
      _controllerImpressora.text = _impressora_recuperada;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ScaffoldMessenger(
        child: Builder(
            builder: (context) => WillPopScope(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Dialog(
                    elevation: 6,
                    insetAnimationDuration: Duration(seconds: 1),
                    insetAnimationCurve: Curves.slowMiddle,
                    insetPadding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                    child: Container(
                      //height: 300.0,
                      width: 200.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Text('Parâmetros', style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900),),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _controllerImpressora,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                labelText: "Nome da Impressora",
                                labelStyle: TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                hoverColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 2, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: (){
                                      //appDatabase.deleteEverything();
                                      _deletar_ultimo_pedido();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: AutoSizeText(
                                      "Deletar Ultimo Pedido",textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 24, color: Colors.white),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: (){
                                      _gerar_relatorio_fechamento();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: AutoSizeText(
                                      "Gerar Relatorio",textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 24, color: Colors.white),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(4),
                              child: Container(
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: (){
                                      _limpar_banco();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: AutoSizeText(
                                      "Limpar Dados",textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 24, color: Colors.white),
                                      maxLines: 1,
                                      minFontSize: 8,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                ),
                              )
                          ),
                          //gera_relatorio
                          Padding(
                              padding: EdgeInsets.all(8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        height: 50,
                                        child: ElevatedButton(
                                            onPressed: (){
                                              _salvar_parametros(_controllerImpressora.text.toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: AutoSizeText(
                                              "Confirmar",textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 24, color: Colors.green),
                                              maxLines: 1,
                                              minFontSize: 8,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                        ),
                                      )
                                  )
                              ),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        height: 50,
                                        child: ElevatedButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                              primary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: AutoSizeText(
                                              "Cancelar",textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 24, color: Colors.red),
                                              maxLines: 1,
                                              minFontSize: 8,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                        ),
                                      )
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onWillPop: () async => false
            )
        ),
      ),
    );
  }

  _salvar_parametros(String impressora) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("impressora", impressora);
    Navigator.of(context).pop();
  }

  _deletar_ultimo_pedido()
  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Excluir Pedido'),
            content: const Text('Deseja realmente excluir o ultimo pedido registrado?'),
            actions: [
              TextButton(
                  onPressed: () {
                    appDatabase.deletarUltimoRegistro(_id_ult_ped - 1);
                    recebe_id_inserir();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'))
            ],
          );
        });
  }
  _limpar_banco()
  {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Limpar Banco de Dados'),
            content: const Text('Deseja realmente excluir todos os registros do banco de dados?\nUma vez executado, nenhum registro poderá ser recuperado.'),
            actions: [
              TextButton(
                  onPressed: () {
                    appDatabase.deleteEverything();
                    recebe_id_inserir();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sim')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Não'))
            ],
          );
        });
  }

  _confirmar_pedido() async{
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String data = DateFormat('dd-MM-yyyy kk:mm:ss').format(now);
    if(prefs.getString("impressora") != null && prefs.getString("impressora") != "")
    {
      String _impressora_recuperada = prefs.getString("impressora").toString();
      final impressao imprimir = impressao();
      for(int i = 0; i < _lista_itens.length; i++)
        {
          Item it = _lista_itens[i];
          for(int y = 0; y < it.qtd; y++)
            {
              imprimir.imprimir(_impressora_recuperada, it);
            }
          appDatabase.insertDado(RelatorioCompanion(
              id_pedido: dr.Value(_id_ult_ped),
              id_item: dr.Value(it.id_item),
              descricao: dr.Value(it.descricao),
              valor: dr.Value(it.valor.toDouble()),
              qtd: dr.Value(it.qtd),
              data: dr.Value(data),
          ));
        }

    }
    else{
      _gera_dialogo_erro_impressora();
    }
    _lista_itens.clear();
    recebe_id_inserir();
    setState(() {

    });
  }

  _gerar_relatorio_fechamento() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("impressora") != null && prefs.getString("impressora") != "")
    {
      String _impressora_recuperada = prefs.getString("impressora").toString();
      await appDatabase.gera_relatorio(_lista_produtos, _impressora_recuperada);
      Navigator.of(context).pop();
    }
    else{
      _gera_dialogo_erro_impressora();
    }
    _lista_itens.clear();
    recebe_id_inserir();
    setState(() {

    });
  }

  _gera_dialogo_erro_impressora(){
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Erro ao Imprimir'),
            content: const Text('Para que seja possível utilizar o sistema, é necessário informar nos parâmetros o nome da impressora que utilizará'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _mostrar_dialogo_parametros();
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  Future<int> _recebe_ultimo_id_db(){
    Future<int> ult_id;
    ult_id = appDatabase.retorna_ultimo_id();
    return ult_id;
  }

  recebe_id_inserir() async{
    _id_ult_ped = await _recebe_ultimo_id_db();
  }

  List<Produto> _popular_lista(){
    List<Produto> _lista_produtos = [];
    Produto item = Produto(1, "CREPE", 20); _lista_produtos.add(item);
    item = Produto(2, "PASTEL", 10); _lista_produtos.add(item);
    item = Produto(3, "BATATA CHIPS", 15); _lista_produtos.add(item);
    item = Produto(4, "PIPOCA", 6); _lista_produtos.add(item);
    item = Produto(5, "ALGODÃO DOCE", 6); _lista_produtos.add(item);
    item = Produto(6, "ESPETO DE MORANGO", 7); _lista_produtos.add(item);
    item = Produto(7, "CAFÉ", 5); _lista_produtos.add(item);
    return _lista_produtos;
  }

  /*
  GridView.count(
                      crossAxisCount: 6,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(_lista_produtos.length, (index) {
                        return Card(
                          elevation: 4,
                          child: InkWell(
                            splashColor: Colors.white,
                            onTap: (){
                              Produto selecionado = _lista_produtos[index];
                              Item adicionar = Item();
                              adicionar.id_item = selecionado.id_item;
                              adicionar.descricao = selecionado.descricao;
                              adicionar.valor = selecionado.valor;
                              adicionar.qtd = 1;
                              _inserir_item_lista(adicionar);
                              setState(() {

                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                height: ((altura * 0.50) - (altura_status_bar/2) - (altura_app_bar/2))/4,
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.monetization_on_outlined,
                                      color: Colors.black,
                                    ),
                                    AutoSizeText(
                                      _lista_produtos[index].descricao.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500
                                      ),
                                      maxLines: 1,
                                      minFontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AutoSizeText(
                                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_produtos[index].valor),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 50,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                )
                            ),
                          ),
                        );
                      }),
                    ),
   */

/*
ListTile(
                                      leading:  CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          Icons.check, color: Colors.white,
                                        ),
                                      ),
                                      title: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 4, 0, 2),
                                        child: Text(
                                          _lista_itens[index].descricao,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: (20),
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                            child: Text(
                                              _lista_itens[index].qtd.toString() + " x " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_itens[index].valor),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: (20),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(0, 2, 0, 4),
                                            child: Text(
                                              "Total: " + NumberFormat.simpleCurrency(locale: 'pt_BR').format(_lista_itens[index].valor * _lista_itens[index].qtd),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: (16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        onPressed: ()
                                        {
                                          _indice_deletar = index;
                                          _deletar_item();
                                        },
                                        alignment: Alignment.bottomCenter,
                                        icon: Icon(Icons.delete_forever, color: Colors.red,),
                                      ),
                                    ),
 */
}

