// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
      'module', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        colorHex,
        module,
        iconName,
        sortOrder,
        archivedAt,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module']!, _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      module: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}archived_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String name;
  final String colorHex;
  final String module;
  final String? iconName;
  final int sortOrder;
  final int? archivedAt;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const CategoriesTableData(
      {required this.id,
      required this.name,
      required this.colorHex,
      required this.module,
      this.iconName,
      required this.sortOrder,
      this.archivedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['module'] = Variable<String>(module);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      module: Value(module),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      sortOrder: Value(sortOrder),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      module: serializer.fromJson<String>(json['module']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archivedAt: serializer.fromJson<int?>(json['archivedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'module': serializer.toJson<String>(module),
      'iconName': serializer.toJson<String?>(iconName),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archivedAt': serializer.toJson<int?>(archivedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  CategoriesTableData copyWith(
          {String? id,
          String? name,
          String? colorHex,
          String? module,
          Value<String?> iconName = const Value.absent(),
          int? sortOrder,
          Value<int?> archivedAt = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      CategoriesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        colorHex: colorHex ?? this.colorHex,
        module: module ?? this.module,
        iconName: iconName.present ? iconName.value : this.iconName,
        sortOrder: sortOrder ?? this.sortOrder,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      module: data.module.present ? data.module.value : this.module,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('module: $module, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex, module, iconName,
      sortOrder, archivedAt, createdAt, updatedAt, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.module == this.module &&
          other.iconName == this.iconName &&
          other.sortOrder == this.sortOrder &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<String> module;
  final Value<String?> iconName;
  final Value<int> sortOrder;
  final Value<int?> archivedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.module = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required String colorHex,
    required String module,
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        colorHex = Value(colorHex),
        module = Value(module),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<String>? module,
    Expression<String>? iconName,
    Expression<int>? sortOrder,
    Expression<int>? archivedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (module != null) 'module': module,
      if (iconName != null) 'icon_name': iconName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? colorHex,
      Value<String>? module,
      Value<String?>? iconName,
      Value<int>? sortOrder,
      Value<int?>? archivedAt,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      module: module ?? this.module,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('module: $module, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyJsonMeta =
      const VerificationMeta('bodyJson');
  @override
  late final GeneratedColumn<String> bodyJson = GeneratedColumn<String>(
      'body_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _categoryIdsMeta =
      const VerificationMeta('categoryIds');
  @override
  late final GeneratedColumn<String> categoryIds = GeneratedColumn<String>(
      'category_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _linksMeta = const VerificationMeta('links');
  @override
  late final GeneratedColumn<String> links = GeneratedColumn<String>(
      'links', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _attachmentUrlsMeta =
      const VerificationMeta('attachmentUrls');
  @override
  late final GeneratedColumn<String> attachmentUrls = GeneratedColumn<String>(
      'attachment_urls', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _contextFieldsMeta =
      const VerificationMeta('contextFields');
  @override
  late final GeneratedColumn<String> contextFields = GeneratedColumn<String>(
      'context_fields', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        bodyJson,
        categoryIds,
        tags,
        links,
        attachmentUrls,
        isPinned,
        isArchived,
        contextFields,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(Insertable<NotesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body_json')) {
      context.handle(_bodyJsonMeta,
          bodyJson.isAcceptableOrUnknown(data['body_json']!, _bodyJsonMeta));
    }
    if (data.containsKey('category_ids')) {
      context.handle(
          _categoryIdsMeta,
          categoryIds.isAcceptableOrUnknown(
              data['category_ids']!, _categoryIdsMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('links')) {
      context.handle(
          _linksMeta, links.isAcceptableOrUnknown(data['links']!, _linksMeta));
    }
    if (data.containsKey('attachment_urls')) {
      context.handle(
          _attachmentUrlsMeta,
          attachmentUrls.isAcceptableOrUnknown(
              data['attachment_urls']!, _attachmentUrlsMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('context_fields')) {
      context.handle(
          _contextFieldsMeta,
          contextFields.isAcceptableOrUnknown(
              data['context_fields']!, _contextFieldsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      bodyJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body_json'])!,
      categoryIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_ids'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      links: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}links'])!,
      attachmentUrls: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attachment_urls'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      contextFields: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context_fields'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final String id;
  final String title;
  final String bodyJson;
  final String categoryIds;
  final String tags;
  final String links;
  final String attachmentUrls;
  final bool isPinned;
  final bool isArchived;
  final String contextFields;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const NotesTableData(
      {required this.id,
      required this.title,
      required this.bodyJson,
      required this.categoryIds,
      required this.tags,
      required this.links,
      required this.attachmentUrls,
      required this.isPinned,
      required this.isArchived,
      required this.contextFields,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body_json'] = Variable<String>(bodyJson);
    map['category_ids'] = Variable<String>(categoryIds);
    map['tags'] = Variable<String>(tags);
    map['links'] = Variable<String>(links);
    map['attachment_urls'] = Variable<String>(attachmentUrls);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_archived'] = Variable<bool>(isArchived);
    map['context_fields'] = Variable<String>(contextFields);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      title: Value(title),
      bodyJson: Value(bodyJson),
      categoryIds: Value(categoryIds),
      tags: Value(tags),
      links: Value(links),
      attachmentUrls: Value(attachmentUrls),
      isPinned: Value(isPinned),
      isArchived: Value(isArchived),
      contextFields: Value(contextFields),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory NotesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      bodyJson: serializer.fromJson<String>(json['bodyJson']),
      categoryIds: serializer.fromJson<String>(json['categoryIds']),
      tags: serializer.fromJson<String>(json['tags']),
      links: serializer.fromJson<String>(json['links']),
      attachmentUrls: serializer.fromJson<String>(json['attachmentUrls']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      contextFields: serializer.fromJson<String>(json['contextFields']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'bodyJson': serializer.toJson<String>(bodyJson),
      'categoryIds': serializer.toJson<String>(categoryIds),
      'tags': serializer.toJson<String>(tags),
      'links': serializer.toJson<String>(links),
      'attachmentUrls': serializer.toJson<String>(attachmentUrls),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isArchived': serializer.toJson<bool>(isArchived),
      'contextFields': serializer.toJson<String>(contextFields),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  NotesTableData copyWith(
          {String? id,
          String? title,
          String? bodyJson,
          String? categoryIds,
          String? tags,
          String? links,
          String? attachmentUrls,
          bool? isPinned,
          bool? isArchived,
          String? contextFields,
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      NotesTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        bodyJson: bodyJson ?? this.bodyJson,
        categoryIds: categoryIds ?? this.categoryIds,
        tags: tags ?? this.tags,
        links: links ?? this.links,
        attachmentUrls: attachmentUrls ?? this.attachmentUrls,
        isPinned: isPinned ?? this.isPinned,
        isArchived: isArchived ?? this.isArchived,
        contextFields: contextFields ?? this.contextFields,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      bodyJson: data.bodyJson.present ? data.bodyJson.value : this.bodyJson,
      categoryIds:
          data.categoryIds.present ? data.categoryIds.value : this.categoryIds,
      tags: data.tags.present ? data.tags.value : this.tags,
      links: data.links.present ? data.links.value : this.links,
      attachmentUrls: data.attachmentUrls.present
          ? data.attachmentUrls.value
          : this.attachmentUrls,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      contextFields: data.contextFields.present
          ? data.contextFields.value
          : this.contextFields,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('categoryIds: $categoryIds, ')
          ..write('tags: $tags, ')
          ..write('links: $links, ')
          ..write('attachmentUrls: $attachmentUrls, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('contextFields: $contextFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      bodyJson,
      categoryIds,
      tags,
      links,
      attachmentUrls,
      isPinned,
      isArchived,
      contextFields,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.bodyJson == this.bodyJson &&
          other.categoryIds == this.categoryIds &&
          other.tags == this.tags &&
          other.links == this.links &&
          other.attachmentUrls == this.attachmentUrls &&
          other.isPinned == this.isPinned &&
          other.isArchived == this.isArchived &&
          other.contextFields == this.contextFields &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> bodyJson;
  final Value<String> categoryIds;
  final Value<String> tags;
  final Value<String> links;
  final Value<String> attachmentUrls;
  final Value<bool> isPinned;
  final Value<bool> isArchived;
  final Value<String> contextFields;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.bodyJson = const Value.absent(),
    this.categoryIds = const Value.absent(),
    this.tags = const Value.absent(),
    this.links = const Value.absent(),
    this.attachmentUrls = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.contextFields = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    required String title,
    this.bodyJson = const Value.absent(),
    this.categoryIds = const Value.absent(),
    this.tags = const Value.absent(),
    this.links = const Value.absent(),
    this.attachmentUrls = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.contextFields = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<NotesTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? bodyJson,
    Expression<String>? categoryIds,
    Expression<String>? tags,
    Expression<String>? links,
    Expression<String>? attachmentUrls,
    Expression<bool>? isPinned,
    Expression<bool>? isArchived,
    Expression<String>? contextFields,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (bodyJson != null) 'body_json': bodyJson,
      if (categoryIds != null) 'category_ids': categoryIds,
      if (tags != null) 'tags': tags,
      if (links != null) 'links': links,
      if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isArchived != null) 'is_archived': isArchived,
      if (contextFields != null) 'context_fields': contextFields,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? bodyJson,
      Value<String>? categoryIds,
      Value<String>? tags,
      Value<String>? links,
      Value<String>? attachmentUrls,
      Value<bool>? isPinned,
      Value<bool>? isArchived,
      Value<String>? contextFields,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return NotesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      bodyJson: bodyJson ?? this.bodyJson,
      categoryIds: categoryIds ?? this.categoryIds,
      tags: tags ?? this.tags,
      links: links ?? this.links,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      contextFields: contextFields ?? this.contextFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bodyJson.present) {
      map['body_json'] = Variable<String>(bodyJson.value);
    }
    if (categoryIds.present) {
      map['category_ids'] = Variable<String>(categoryIds.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (links.present) {
      map['links'] = Variable<String>(links.value);
    }
    if (attachmentUrls.present) {
      map['attachment_urls'] = Variable<String>(attachmentUrls.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (contextFields.present) {
      map['context_fields'] = Variable<String>(contextFields.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('categoryIds: $categoryIds, ')
          ..write('tags: $tags, ')
          ..write('links: $links, ')
          ..write('attachmentUrls: $attachmentUrls, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('contextFields: $contextFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _categoryIdsMeta =
      const VerificationMeta('categoryIds');
  @override
  late final GeneratedColumn<String> categoryIds = GeneratedColumn<String>(
      'category_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
      'due_date', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dueTimeMeta =
      const VerificationMeta('dueTime');
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
      'due_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('none'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('notStarted'));
  static const VerificationMeta _subTasksMeta =
      const VerificationMeta('subTasks');
  @override
  late final GeneratedColumn<String> subTasks = GeneratedColumn<String>(
      'sub_tasks', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _linksMeta = const VerificationMeta('links');
  @override
  late final GeneratedColumn<String> links = GeneratedColumn<String>(
      'links', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _recurrenceMeta =
      const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
      'recurrence', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remindersMeta =
      const VerificationMeta('reminders');
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
      'reminders', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _contextFieldsMeta =
      const VerificationMeta('contextFields');
  @override
  late final GeneratedColumn<String> contextFields = GeneratedColumn<String>(
      'context_fields', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _isMasterRecurringMeta =
      const VerificationMeta('isMasterRecurring');
  @override
  late final GeneratedColumn<bool> isMasterRecurring = GeneratedColumn<bool>(
      'is_master_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_master_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _masterTaskIdMeta =
      const VerificationMeta('masterTaskId');
  @override
  late final GeneratedColumn<String> masterTaskId = GeneratedColumn<String>(
      'master_task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        categoryIds,
        dueDate,
        dueTime,
        priority,
        status,
        subTasks,
        links,
        recurrence,
        reminders,
        contextFields,
        isMasterRecurring,
        masterTaskId,
        createdAt,
        updatedAt,
        syncStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(Insertable<TasksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category_ids')) {
      context.handle(
          _categoryIdsMeta,
          categoryIds.isAcceptableOrUnknown(
              data['category_ids']!, _categoryIdsMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('due_time')) {
      context.handle(_dueTimeMeta,
          dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('sub_tasks')) {
      context.handle(_subTasksMeta,
          subTasks.isAcceptableOrUnknown(data['sub_tasks']!, _subTasksMeta));
    }
    if (data.containsKey('links')) {
      context.handle(
          _linksMeta, links.isAcceptableOrUnknown(data['links']!, _linksMeta));
    }
    if (data.containsKey('recurrence')) {
      context.handle(
          _recurrenceMeta,
          recurrence.isAcceptableOrUnknown(
              data['recurrence']!, _recurrenceMeta));
    }
    if (data.containsKey('reminders')) {
      context.handle(_remindersMeta,
          reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta));
    }
    if (data.containsKey('context_fields')) {
      context.handle(
          _contextFieldsMeta,
          contextFields.isAcceptableOrUnknown(
              data['context_fields']!, _contextFieldsMeta));
    }
    if (data.containsKey('is_master_recurring')) {
      context.handle(
          _isMasterRecurringMeta,
          isMasterRecurring.isAcceptableOrUnknown(
              data['is_master_recurring']!, _isMasterRecurringMeta));
    }
    if (data.containsKey('master_task_id')) {
      context.handle(
          _masterTaskIdMeta,
          masterTaskId.isAcceptableOrUnknown(
              data['master_task_id']!, _masterTaskIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      categoryIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_ids'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_date']),
      dueTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_time']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sub_tasks'])!,
      links: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}links'])!,
      recurrence: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recurrence']),
      reminders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminders'])!,
      contextFields: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}context_fields'])!,
      isMasterRecurring: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_master_recurring'])!,
      masterTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}master_task_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String title;
  final String description;
  final String categoryIds;
  final int? dueDate;
  final String? dueTime;
  final String priority;
  final String status;
  final String subTasks;
  final String links;
  final String? recurrence;
  final String reminders;
  final String contextFields;
  final bool isMasterRecurring;
  final String? masterTaskId;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;
  const TasksTableData(
      {required this.id,
      required this.title,
      required this.description,
      required this.categoryIds,
      this.dueDate,
      this.dueTime,
      required this.priority,
      required this.status,
      required this.subTasks,
      required this.links,
      this.recurrence,
      required this.reminders,
      required this.contextFields,
      required this.isMasterRecurring,
      this.masterTaskId,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category_ids'] = Variable<String>(categoryIds);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['sub_tasks'] = Variable<String>(subTasks);
    map['links'] = Variable<String>(links);
    if (!nullToAbsent || recurrence != null) {
      map['recurrence'] = Variable<String>(recurrence);
    }
    map['reminders'] = Variable<String>(reminders);
    map['context_fields'] = Variable<String>(contextFields);
    map['is_master_recurring'] = Variable<bool>(isMasterRecurring);
    if (!nullToAbsent || masterTaskId != null) {
      map['master_task_id'] = Variable<String>(masterTaskId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      categoryIds: Value(categoryIds),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      priority: Value(priority),
      status: Value(status),
      subTasks: Value(subTasks),
      links: Value(links),
      recurrence: recurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrence),
      reminders: Value(reminders),
      contextFields: Value(contextFields),
      isMasterRecurring: Value(isMasterRecurring),
      masterTaskId: masterTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(masterTaskId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory TasksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      categoryIds: serializer.fromJson<String>(json['categoryIds']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      subTasks: serializer.fromJson<String>(json['subTasks']),
      links: serializer.fromJson<String>(json['links']),
      recurrence: serializer.fromJson<String?>(json['recurrence']),
      reminders: serializer.fromJson<String>(json['reminders']),
      contextFields: serializer.fromJson<String>(json['contextFields']),
      isMasterRecurring: serializer.fromJson<bool>(json['isMasterRecurring']),
      masterTaskId: serializer.fromJson<String?>(json['masterTaskId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'categoryIds': serializer.toJson<String>(categoryIds),
      'dueDate': serializer.toJson<int?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'subTasks': serializer.toJson<String>(subTasks),
      'links': serializer.toJson<String>(links),
      'recurrence': serializer.toJson<String?>(recurrence),
      'reminders': serializer.toJson<String>(reminders),
      'contextFields': serializer.toJson<String>(contextFields),
      'isMasterRecurring': serializer.toJson<bool>(isMasterRecurring),
      'masterTaskId': serializer.toJson<String?>(masterTaskId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  TasksTableData copyWith(
          {String? id,
          String? title,
          String? description,
          String? categoryIds,
          Value<int?> dueDate = const Value.absent(),
          Value<String?> dueTime = const Value.absent(),
          String? priority,
          String? status,
          String? subTasks,
          String? links,
          Value<String?> recurrence = const Value.absent(),
          String? reminders,
          String? contextFields,
          bool? isMasterRecurring,
          Value<String?> masterTaskId = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          String? syncStatus}) =>
      TasksTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        categoryIds: categoryIds ?? this.categoryIds,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        dueTime: dueTime.present ? dueTime.value : this.dueTime,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        subTasks: subTasks ?? this.subTasks,
        links: links ?? this.links,
        recurrence: recurrence.present ? recurrence.value : this.recurrence,
        reminders: reminders ?? this.reminders,
        contextFields: contextFields ?? this.contextFields,
        isMasterRecurring: isMasterRecurring ?? this.isMasterRecurring,
        masterTaskId:
            masterTaskId.present ? masterTaskId.value : this.masterTaskId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      categoryIds:
          data.categoryIds.present ? data.categoryIds.value : this.categoryIds,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      subTasks: data.subTasks.present ? data.subTasks.value : this.subTasks,
      links: data.links.present ? data.links.value : this.links,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      contextFields: data.contextFields.present
          ? data.contextFields.value
          : this.contextFields,
      isMasterRecurring: data.isMasterRecurring.present
          ? data.isMasterRecurring.value
          : this.isMasterRecurring,
      masterTaskId: data.masterTaskId.present
          ? data.masterTaskId.value
          : this.masterTaskId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('categoryIds: $categoryIds, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('subTasks: $subTasks, ')
          ..write('links: $links, ')
          ..write('recurrence: $recurrence, ')
          ..write('reminders: $reminders, ')
          ..write('contextFields: $contextFields, ')
          ..write('isMasterRecurring: $isMasterRecurring, ')
          ..write('masterTaskId: $masterTaskId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      categoryIds,
      dueDate,
      dueTime,
      priority,
      status,
      subTasks,
      links,
      recurrence,
      reminders,
      contextFields,
      isMasterRecurring,
      masterTaskId,
      createdAt,
      updatedAt,
      syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.categoryIds == this.categoryIds &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.subTasks == this.subTasks &&
          other.links == this.links &&
          other.recurrence == this.recurrence &&
          other.reminders == this.reminders &&
          other.contextFields == this.contextFields &&
          other.isMasterRecurring == this.isMasterRecurring &&
          other.masterTaskId == this.masterTaskId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> categoryIds;
  final Value<int?> dueDate;
  final Value<String?> dueTime;
  final Value<String> priority;
  final Value<String> status;
  final Value<String> subTasks;
  final Value<String> links;
  final Value<String?> recurrence;
  final Value<String> reminders;
  final Value<String> contextFields;
  final Value<bool> isMasterRecurring;
  final Value<String?> masterTaskId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryIds = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.links = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.reminders = const Value.absent(),
    this.contextFields = const Value.absent(),
    this.isMasterRecurring = const Value.absent(),
    this.masterTaskId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.categoryIds = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.links = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.reminders = const Value.absent(),
    this.contextFields = const Value.absent(),
    this.isMasterRecurring = const Value.absent(),
    this.masterTaskId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? categoryIds,
    Expression<int>? dueDate,
    Expression<String>? dueTime,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<String>? subTasks,
    Expression<String>? links,
    Expression<String>? recurrence,
    Expression<String>? reminders,
    Expression<String>? contextFields,
    Expression<bool>? isMasterRecurring,
    Expression<String>? masterTaskId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (categoryIds != null) 'category_ids': categoryIds,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (subTasks != null) 'sub_tasks': subTasks,
      if (links != null) 'links': links,
      if (recurrence != null) 'recurrence': recurrence,
      if (reminders != null) 'reminders': reminders,
      if (contextFields != null) 'context_fields': contextFields,
      if (isMasterRecurring != null) 'is_master_recurring': isMasterRecurring,
      if (masterTaskId != null) 'master_task_id': masterTaskId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<String>? categoryIds,
      Value<int?>? dueDate,
      Value<String?>? dueTime,
      Value<String>? priority,
      Value<String>? status,
      Value<String>? subTasks,
      Value<String>? links,
      Value<String?>? recurrence,
      Value<String>? reminders,
      Value<String>? contextFields,
      Value<bool>? isMasterRecurring,
      Value<String?>? masterTaskId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryIds: categoryIds ?? this.categoryIds,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subTasks: subTasks ?? this.subTasks,
      links: links ?? this.links,
      recurrence: recurrence ?? this.recurrence,
      reminders: reminders ?? this.reminders,
      contextFields: contextFields ?? this.contextFields,
      isMasterRecurring: isMasterRecurring ?? this.isMasterRecurring,
      masterTaskId: masterTaskId ?? this.masterTaskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryIds.present) {
      map['category_ids'] = Variable<String>(categoryIds.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subTasks.present) {
      map['sub_tasks'] = Variable<String>(subTasks.value);
    }
    if (links.present) {
      map['links'] = Variable<String>(links.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (contextFields.present) {
      map['context_fields'] = Variable<String>(contextFields.value);
    }
    if (isMasterRecurring.present) {
      map['is_master_recurring'] = Variable<bool>(isMasterRecurring.value);
    }
    if (masterTaskId.present) {
      map['master_task_id'] = Variable<String>(masterTaskId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('categoryIds: $categoryIds, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('subTasks: $subTasks, ')
          ..write('links: $links, ')
          ..write('recurrence: $recurrence, ')
          ..write('reminders: $reminders, ')
          ..write('contextFields: $contextFields, ')
          ..write('isMasterRecurring: $isMasterRecurring, ')
          ..write('masterTaskId: $masterTaskId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final NotesDao notesDao = NotesDao(this as AppDatabase);
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categoriesTable, notesTable, tasksTable];
}

typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String id,
  required String name,
  required String colorHex,
  required String module,
  Value<String?> iconName,
  Value<int> sortOrder,
  Value<int?> archivedAt,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> colorHex,
  Value<String> module,
  Value<String?> iconName,
  Value<int> sortOrder,
  Value<int?> archivedAt,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String> module = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int?> archivedAt = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            name: name,
            colorHex: colorHex,
            module: module,
            iconName: iconName,
            sortOrder: sortOrder,
            archivedAt: archivedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String colorHex,
            required String module,
            Value<String?> iconName = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int?> archivedAt = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            name: name,
            colorHex: colorHex,
            module: module,
            iconName: iconName,
            sortOrder: sortOrder,
            archivedAt: archivedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get module => $state.composableBuilder(
      column: $state.table.module,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get archivedAt => $state.composableBuilder(
      column: $state.table.archivedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get colorHex => $state.composableBuilder(
      column: $state.table.colorHex,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get module => $state.composableBuilder(
      column: $state.table.module,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get iconName => $state.composableBuilder(
      column: $state.table.iconName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get archivedAt => $state.composableBuilder(
      column: $state.table.archivedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  required String title,
  Value<String> bodyJson,
  Value<String> categoryIds,
  Value<String> tags,
  Value<String> links,
  Value<String> attachmentUrls,
  Value<bool> isPinned,
  Value<bool> isArchived,
  Value<String> contextFields,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> bodyJson,
  Value<String> categoryIds,
  Value<String> tags,
  Value<String> links,
  Value<String> attachmentUrls,
  Value<bool> isPinned,
  Value<bool> isArchived,
  Value<String> contextFields,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$NotesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTableTable,
    NotesTableData,
    $$NotesTableTableFilterComposer,
    $$NotesTableTableOrderingComposer,
    $$NotesTableTableCreateCompanionBuilder,
    $$NotesTableTableUpdateCompanionBuilder> {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$NotesTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$NotesTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> bodyJson = const Value.absent(),
            Value<String> categoryIds = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> links = const Value.absent(),
            Value<String> attachmentUrls = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<String> contextFields = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion(
            id: id,
            title: title,
            bodyJson: bodyJson,
            categoryIds: categoryIds,
            tags: tags,
            links: links,
            attachmentUrls: attachmentUrls,
            isPinned: isPinned,
            isArchived: isArchived,
            contextFields: contextFields,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> bodyJson = const Value.absent(),
            Value<String> categoryIds = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> links = const Value.absent(),
            Value<String> attachmentUrls = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<String> contextFields = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesTableCompanion.insert(
            id: id,
            title: title,
            bodyJson: bodyJson,
            categoryIds: categoryIds,
            tags: tags,
            links: links,
            attachmentUrls: attachmentUrls,
            isPinned: isPinned,
            isArchived: isArchived,
            contextFields: contextFields,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
        ));
}

class $$NotesTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bodyJson => $state.composableBuilder(
      column: $state.table.bodyJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryIds => $state.composableBuilder(
      column: $state.table.categoryIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get links => $state.composableBuilder(
      column: $state.table.links,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get attachmentUrls => $state.composableBuilder(
      column: $state.table.attachmentUrls,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isPinned => $state.composableBuilder(
      column: $state.table.isPinned,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isArchived => $state.composableBuilder(
      column: $state.table.isArchived,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contextFields => $state.composableBuilder(
      column: $state.table.contextFields,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$NotesTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bodyJson => $state.composableBuilder(
      column: $state.table.bodyJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryIds => $state.composableBuilder(
      column: $state.table.categoryIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get links => $state.composableBuilder(
      column: $state.table.links,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get attachmentUrls => $state.composableBuilder(
      column: $state.table.attachmentUrls,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isPinned => $state.composableBuilder(
      column: $state.table.isPinned,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isArchived => $state.composableBuilder(
      column: $state.table.isArchived,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contextFields => $state.composableBuilder(
      column: $state.table.contextFields,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String id,
  required String title,
  Value<String> description,
  Value<String> categoryIds,
  Value<int?> dueDate,
  Value<String?> dueTime,
  Value<String> priority,
  Value<String> status,
  Value<String> subTasks,
  Value<String> links,
  Value<String?> recurrence,
  Value<String> reminders,
  Value<String> contextFields,
  Value<bool> isMasterRecurring,
  Value<String?> masterTaskId,
  required int createdAt,
  required int updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<String> categoryIds,
  Value<int?> dueDate,
  Value<String?> dueTime,
  Value<String> priority,
  Value<String> status,
  Value<String> subTasks,
  Value<String> links,
  Value<String?> recurrence,
  Value<String> reminders,
  Value<String> contextFields,
  Value<bool> isMasterRecurring,
  Value<String?> masterTaskId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$TasksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder> {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TasksTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TasksTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> categoryIds = const Value.absent(),
            Value<int?> dueDate = const Value.absent(),
            Value<String?> dueTime = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> subTasks = const Value.absent(),
            Value<String> links = const Value.absent(),
            Value<String?> recurrence = const Value.absent(),
            Value<String> reminders = const Value.absent(),
            Value<String> contextFields = const Value.absent(),
            Value<bool> isMasterRecurring = const Value.absent(),
            Value<String?> masterTaskId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion(
            id: id,
            title: title,
            description: description,
            categoryIds: categoryIds,
            dueDate: dueDate,
            dueTime: dueTime,
            priority: priority,
            status: status,
            subTasks: subTasks,
            links: links,
            recurrence: recurrence,
            reminders: reminders,
            contextFields: contextFields,
            isMasterRecurring: isMasterRecurring,
            masterTaskId: masterTaskId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> description = const Value.absent(),
            Value<String> categoryIds = const Value.absent(),
            Value<int?> dueDate = const Value.absent(),
            Value<String?> dueTime = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> subTasks = const Value.absent(),
            Value<String> links = const Value.absent(),
            Value<String?> recurrence = const Value.absent(),
            Value<String> reminders = const Value.absent(),
            Value<String> contextFields = const Value.absent(),
            Value<bool> isMasterRecurring = const Value.absent(),
            Value<String?> masterTaskId = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            categoryIds: categoryIds,
            dueDate: dueDate,
            dueTime: dueTime,
            priority: priority,
            status: status,
            subTasks: subTasks,
            links: links,
            recurrence: recurrence,
            reminders: reminders,
            contextFields: contextFields,
            isMasterRecurring: isMasterRecurring,
            masterTaskId: masterTaskId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
        ));
}

class $$TasksTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryIds => $state.composableBuilder(
      column: $state.table.categoryIds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dueTime => $state.composableBuilder(
      column: $state.table.dueTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get priority => $state.composableBuilder(
      column: $state.table.priority,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get subTasks => $state.composableBuilder(
      column: $state.table.subTasks,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get links => $state.composableBuilder(
      column: $state.table.links,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get recurrence => $state.composableBuilder(
      column: $state.table.recurrence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get reminders => $state.composableBuilder(
      column: $state.table.reminders,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contextFields => $state.composableBuilder(
      column: $state.table.contextFields,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isMasterRecurring => $state.composableBuilder(
      column: $state.table.isMasterRecurring,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get masterTaskId => $state.composableBuilder(
      column: $state.table.masterTaskId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TasksTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryIds => $state.composableBuilder(
      column: $state.table.categoryIds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dueTime => $state.composableBuilder(
      column: $state.table.dueTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get priority => $state.composableBuilder(
      column: $state.table.priority,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subTasks => $state.composableBuilder(
      column: $state.table.subTasks,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get links => $state.composableBuilder(
      column: $state.table.links,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get recurrence => $state.composableBuilder(
      column: $state.table.recurrence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get reminders => $state.composableBuilder(
      column: $state.table.reminders,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contextFields => $state.composableBuilder(
      column: $state.table.contextFields,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isMasterRecurring => $state.composableBuilder(
      column: $state.table.isMasterRecurring,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get masterTaskId => $state.composableBuilder(
      column: $state.table.masterTaskId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
}
