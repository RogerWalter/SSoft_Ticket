// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RelatorioData extends DataClass implements Insertable<RelatorioData> {
  final int id;
  final int id_pedido;
  final int id_item;
  final String descricao;
  final double? valor;
  final int? qtd;
  final String data;
  RelatorioData(
      {required this.id,
      required this.id_pedido,
      required this.id_item,
      required this.descricao,
      this.valor,
      this.qtd,
      required this.data});
  factory RelatorioData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return RelatorioData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      id_pedido: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_pedido'])!,
      id_item: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id_item'])!,
      descricao: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descricao'])!,
      valor: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}valor']),
      qtd: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}qtd']),
      data: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_pedido'] = Variable<int>(id_pedido);
    map['id_item'] = Variable<int>(id_item);
    map['descricao'] = Variable<String>(descricao);
    if (!nullToAbsent || valor != null) {
      map['valor'] = Variable<double?>(valor);
    }
    if (!nullToAbsent || qtd != null) {
      map['qtd'] = Variable<int?>(qtd);
    }
    map['data'] = Variable<String>(data);
    return map;
  }

  RelatorioCompanion toCompanion(bool nullToAbsent) {
    return RelatorioCompanion(
      id: Value(id),
      id_pedido: Value(id_pedido),
      id_item: Value(id_item),
      descricao: Value(descricao),
      valor:
          valor == null && nullToAbsent ? const Value.absent() : Value(valor),
      qtd: qtd == null && nullToAbsent ? const Value.absent() : Value(qtd),
      data: Value(data),
    );
  }

  factory RelatorioData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelatorioData(
      id: serializer.fromJson<int>(json['id']),
      id_pedido: serializer.fromJson<int>(json['id_pedido']),
      id_item: serializer.fromJson<int>(json['id_item']),
      descricao: serializer.fromJson<String>(json['descricao']),
      valor: serializer.fromJson<double?>(json['valor']),
      qtd: serializer.fromJson<int?>(json['qtd']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'id_pedido': serializer.toJson<int>(id_pedido),
      'id_item': serializer.toJson<int>(id_item),
      'descricao': serializer.toJson<String>(descricao),
      'valor': serializer.toJson<double?>(valor),
      'qtd': serializer.toJson<int?>(qtd),
      'data': serializer.toJson<String>(data),
    };
  }

  RelatorioData copyWith(
          {int? id,
          int? id_pedido,
          int? id_item,
          String? descricao,
          double? valor,
          int? qtd,
          String? data}) =>
      RelatorioData(
        id: id ?? this.id,
        id_pedido: id_pedido ?? this.id_pedido,
        id_item: id_item ?? this.id_item,
        descricao: descricao ?? this.descricao,
        valor: valor ?? this.valor,
        qtd: qtd ?? this.qtd,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('RelatorioData(')
          ..write('id: $id, ')
          ..write('id_pedido: $id_pedido, ')
          ..write('id_item: $id_item, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor, ')
          ..write('qtd: $qtd, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, id_pedido, id_item, descricao, valor, qtd, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelatorioData &&
          other.id == this.id &&
          other.id_pedido == this.id_pedido &&
          other.id_item == this.id_item &&
          other.descricao == this.descricao &&
          other.valor == this.valor &&
          other.qtd == this.qtd &&
          other.data == this.data);
}

class RelatorioCompanion extends UpdateCompanion<RelatorioData> {
  final Value<int> id;
  final Value<int> id_pedido;
  final Value<int> id_item;
  final Value<String> descricao;
  final Value<double?> valor;
  final Value<int?> qtd;
  final Value<String> data;
  const RelatorioCompanion({
    this.id = const Value.absent(),
    this.id_pedido = const Value.absent(),
    this.id_item = const Value.absent(),
    this.descricao = const Value.absent(),
    this.valor = const Value.absent(),
    this.qtd = const Value.absent(),
    this.data = const Value.absent(),
  });
  RelatorioCompanion.insert({
    this.id = const Value.absent(),
    required int id_pedido,
    required int id_item,
    required String descricao,
    this.valor = const Value.absent(),
    this.qtd = const Value.absent(),
    required String data,
  })  : id_pedido = Value(id_pedido),
        id_item = Value(id_item),
        descricao = Value(descricao),
        data = Value(data);
  static Insertable<RelatorioData> custom({
    Expression<int>? id,
    Expression<int>? id_pedido,
    Expression<int>? id_item,
    Expression<String>? descricao,
    Expression<double?>? valor,
    Expression<int?>? qtd,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (id_pedido != null) 'id_pedido': id_pedido,
      if (id_item != null) 'id_item': id_item,
      if (descricao != null) 'descricao': descricao,
      if (valor != null) 'valor': valor,
      if (qtd != null) 'qtd': qtd,
      if (data != null) 'data': data,
    });
  }

  RelatorioCompanion copyWith(
      {Value<int>? id,
      Value<int>? id_pedido,
      Value<int>? id_item,
      Value<String>? descricao,
      Value<double?>? valor,
      Value<int?>? qtd,
      Value<String>? data}) {
    return RelatorioCompanion(
      id: id ?? this.id,
      id_pedido: id_pedido ?? this.id_pedido,
      id_item: id_item ?? this.id_item,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      qtd: qtd ?? this.qtd,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (id_pedido.present) {
      map['id_pedido'] = Variable<int>(id_pedido.value);
    }
    if (id_item.present) {
      map['id_item'] = Variable<int>(id_item.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double?>(valor.value);
    }
    if (qtd.present) {
      map['qtd'] = Variable<int?>(qtd.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelatorioCompanion(')
          ..write('id: $id, ')
          ..write('id_pedido: $id_pedido, ')
          ..write('id_item: $id_item, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor, ')
          ..write('qtd: $qtd, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $RelatorioTable extends Relatorio
    with TableInfo<$RelatorioTable, RelatorioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelatorioTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _id_pedidoMeta = const VerificationMeta('id_pedido');
  @override
  late final GeneratedColumn<int?> id_pedido = GeneratedColumn<int?>(
      'id_pedido', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _id_itemMeta = const VerificationMeta('id_item');
  @override
  late final GeneratedColumn<int?> id_item = GeneratedColumn<int?>(
      'id_item', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String?> descricao = GeneratedColumn<String?>(
      'descricao', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double?> valor = GeneratedColumn<double?>(
      'valor', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _qtdMeta = const VerificationMeta('qtd');
  @override
  late final GeneratedColumn<int?> qtd = GeneratedColumn<int?>(
      'qtd', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String?> data = GeneratedColumn<String?>(
      'data', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, id_pedido, id_item, descricao, valor, qtd, data];
  @override
  String get aliasedName => _alias ?? 'relatorio';
  @override
  String get actualTableName => 'relatorio';
  @override
  VerificationContext validateIntegrity(Insertable<RelatorioData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_pedido')) {
      context.handle(_id_pedidoMeta,
          id_pedido.isAcceptableOrUnknown(data['id_pedido']!, _id_pedidoMeta));
    } else if (isInserting) {
      context.missing(_id_pedidoMeta);
    }
    if (data.containsKey('id_item')) {
      context.handle(_id_itemMeta,
          id_item.isAcceptableOrUnknown(data['id_item']!, _id_itemMeta));
    } else if (isInserting) {
      context.missing(_id_itemMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    }
    if (data.containsKey('qtd')) {
      context.handle(
          _qtdMeta, qtd.isAcceptableOrUnknown(data['qtd']!, _qtdMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelatorioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return RelatorioData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $RelatorioTable createAlias(String alias) {
    return $RelatorioTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $RelatorioTable relatorio = $RelatorioTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [relatorio];
}
