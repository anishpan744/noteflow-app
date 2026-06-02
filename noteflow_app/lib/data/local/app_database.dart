import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'categories_dao.dart';
import 'notes_dao.dart';
import 'tasks_dao.dart';

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

class CategoriesTable extends Table {
  TextColumn get id          => text()();
  TextColumn get name        => text()();
  TextColumn get colorHex    => text()();
  TextColumn get module      => text()();
  TextColumn get iconName    => text().nullable()();
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
  IntColumn  get archivedAt  => integer().nullable()();
  IntColumn  get createdAt   => integer()();
  IntColumn  get updatedAt   => integer()();
  TextColumn get syncStatus  => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class NotesTable extends Table {
  TextColumn  get id             => text()();
  TextColumn  get title          => text()();
  TextColumn  get bodyJson       => text().withDefault(const Constant(''))();
  TextColumn  get categoryIds    => text().withDefault(const Constant('[]'))();
  TextColumn  get tags           => text().withDefault(const Constant('[]'))();
  TextColumn  get links          => text().withDefault(const Constant('[]'))();
  TextColumn  get attachmentUrls => text().withDefault(const Constant('[]'))();
  BoolColumn  get isPinned       => boolean().withDefault(const Constant(false))();
  BoolColumn  get isArchived     => boolean().withDefault(const Constant(false))();
  TextColumn  get contextFields  => text().withDefault(const Constant('{}'))();
  IntColumn   get createdAt      => integer()();
  IntColumn   get updatedAt      => integer()();
  TextColumn  get syncStatus     => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class TasksTable extends Table {
  TextColumn  get id                => text()();
  TextColumn  get title             => text()();
  TextColumn  get description       => text().withDefault(const Constant(''))();
  TextColumn  get categoryIds       => text().withDefault(const Constant('[]'))();
  IntColumn   get dueDate           => integer().nullable()();
  TextColumn  get dueTime           => text().nullable()();
  TextColumn  get priority          => text().withDefault(const Constant('none'))();
  TextColumn  get status            => text().withDefault(const Constant('notStarted'))();
  TextColumn  get subTasks          => text().withDefault(const Constant('[]'))();
  TextColumn  get links             => text().withDefault(const Constant('[]'))();
  TextColumn  get recurrence        => text().nullable()();
  TextColumn  get reminders         => text().withDefault(const Constant('[]'))();
  TextColumn  get contextFields     => text().withDefault(const Constant('{}'))();
  BoolColumn  get isMasterRecurring => boolean().withDefault(const Constant(false))();
  TextColumn  get masterTaskId      => text().nullable()();
  IntColumn   get createdAt         => integer()();
  IntColumn   get updatedAt         => integer()();
  TextColumn  get syncStatus        => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [CategoriesTable, NotesTable, TasksTable],
  daos:   [CategoriesDao, NotesDao, TasksDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir  = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'noteflow.db'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
