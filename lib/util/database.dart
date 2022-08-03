import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:ssoft_ticket/model/Item.dart';
import 'package:ssoft_ticket/model/Produto.dart';
import 'package:ssoft_ticket/util/impressao.dart';
part 'database.g.dart';


class Relatorio extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get id_pedido => integer()();
  IntColumn get id_item => integer()();
  TextColumn get descricao => text().named('descricao')();
  RealColumn get valor => real().nullable()();
  IntColumn get qtd => integer().nullable()();
  TextColumn get data => text().named('data')();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Relatorio])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(relatorio, relatorio.id_pedido);
        }
        if (from < 3) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(relatorio, relatorio.data);
        }
      },
    );
  }
  //GET ALL
  Future<List<RelatorioData>> getRelatorioList() async {
    return await select(relatorio).get();
  }

  //INSERT
  Future<int> insertDado(RelatorioCompanion relatorioCompanion) async {
    List<RelatorioData> lista = await getRelatorioList();
    print(lista);
    return await into(relatorio).insert(relatorioCompanion);
  }

  //DELETE
  Future<int> deleteDado(RelatorioData relatorioData) async {
    return await delete(relatorio).delete(relatorioData);
  }
  //DELETAR ULTIMO REGISTRO
  Future deletarUltimoRegistro(int id_deletar) {
    return (delete(relatorio)..where((t) => t.id_pedido.equals(id_deletar))).go();
  }

  Future<int> deleteTabela() async {
    return await delete(relatorio).go();
  }
  //LIMPAR BANCO
  Future<void> deleteEverything() {
    return transaction(() async {
      // you only need this if you've manually enabled foreign keys
      // await customStatement('PRAGMA foreign_keys = OFF');
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  // UPDATE
  Future<bool> updateDado(RelatorioData relatorioData) async {
    return await update(relatorio).replace(relatorioData);
  }

  Future<int> retorna_ultimo_id()async{
    int ult_id = 0;
    List<RelatorioData> lista = await getRelatorioList();
    if(lista.length > 0)
      ult_id = lista.last.id_pedido + 1;
    return ult_id;
  }

  gera_relatorio(List<Produto> lista_produtos, String impressora) async{
    List<RelatorioData> lista = await getRelatorioList();
    double total_fechamento = 0;
    List<Item> relatorio_mostrar = [];
    if(lista.length > 0){
      for(RelatorioData it in lista)
      {
        int? qtd = it.qtd;
        double? valor = it.valor;
        double? _parcial = 0;
        _parcial = qtd! * valor!;
        total_fechamento = total_fechamento + _parcial;
      }
      for(Produto prod in lista_produtos){
        int? id_relatorio = prod.id_item;
        double total_item = 0;
        int qtd_item = 0;
        for(int y = 0; y < lista.length; y++){
          if(lista[y].id_item == id_relatorio){
            int? qtd = lista[y].qtd;
            qtd_item = qtd! + qtd_item;
            double? valor = lista[y].valor;
            double? _parcial_item = 0;
            _parcial_item = qtd! * valor!;
            total_item = total_item + _parcial_item;
          }
        }
        Item add_rel = Item();
        add_rel.id_item = id_relatorio;
        add_rel.descricao = prod.descricao;
        add_rel.qtd = qtd_item;
        add_rel.valor = total_item;
        relatorio_mostrar.add(add_rel);
      }
      impressao imprimir = impressao();
      imprimir.imprimir_relatorio(impressora, relatorio_mostrar, total_fechamento);
    }
  }
}