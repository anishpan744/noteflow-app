import 'package:drift/drift.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import 'app_database.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  // ── Queries ─────────────────────────────────────────────────────────────────

  Stream<List<Category>> watchAll() {
    return (select(categoriesTable)
          ..where((t) => t.syncStatus.isNotValue('deleted'))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<Category?> watchById(String id) {
    return (select(categoriesTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _fromRow(row));
  }

  Future<List<Category>> getPending() async {
    final rows = await (select(categoriesTable)
          ..where((t) => t.syncStatus.equals('pending')))
        .get();
    return rows.map(_fromRow).toList();
  }

  // ── Mutations ────────────────────────────────────────────────────────────────

  Future<void> upsert(Category category) {
    return into(categoriesTable).insertOnConflictUpdate(_toCompanion(category));
  }

  Future<void> deleteById(String id) {
    return (update(categoriesTable)..where((t) => t.id.equals(id)))
        .write(const CategoriesTableCompanion(syncStatus: Value('deleted')));
  }

  Future<void> markSynced(String id) {
    return (update(categoriesTable)..where((t) => t.id.equals(id)))
        .write(const CategoriesTableCompanion(syncStatus: Value('synced')));
  }

  // ── Converters ───────────────────────────────────────────────────────────────

  Category _fromRow(CategoriesTableData r) => Category(
        id:         r.id,
        name:       r.name,
        colorHex:   r.colorHex,
        module:     CategoryModule.values.firstWhere(
            (e) => e.name == r.module,
            orElse: () => CategoryModule.shared),
        iconName:   r.iconName,
        sortOrder:  r.sortOrder,
        archivedAt: r.archivedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(r.archivedAt!)
            : null,
        createdAt:  DateTime.fromMillisecondsSinceEpoch(r.createdAt),
        updatedAt:  DateTime.fromMillisecondsSinceEpoch(r.updatedAt),
      );

  CategoriesTableCompanion _toCompanion(Category c) =>
      CategoriesTableCompanion.insert(
        id:         c.id,
        name:       c.name,
        colorHex:   c.colorHex,
        module:     c.module.name,
        iconName:   Value(c.iconName),
        sortOrder:  Value(c.sortOrder),
        archivedAt: Value(c.archivedAt?.millisecondsSinceEpoch),
        createdAt:  c.createdAt.millisecondsSinceEpoch,
        updatedAt:  c.updatedAt.millisecondsSinceEpoch,
        syncStatus: const Value('pending'),
      );
}

