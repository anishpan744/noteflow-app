import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/auth_providers.dart';
import '../../models/category.dart';
import '../local/app_database.dart';
import '../local/categories_dao.dart';
import '../remote/firestore_categories_datasource.dart';
import 'sync_service.dart';

class CategoryRepository {
  CategoryRepository({
    required CategoriesDao dao,
    required FirestoreCategoriesDatasource remote,
    required SyncService sync,
  })  : _dao = dao,
        _remote = remote,
        _sync = sync {
    // Mirror Firestore → Drift in background
    _remote.watchAll().listen(
      (categories) async {
        for (final c in categories) {
          await _dao.upsert(c);
          await _dao.markSynced(c.id);
        }
      },
      onError: (_) {}, // silently ignore offline errors
    );
  }

  final CategoriesDao _dao;
  final FirestoreCategoriesDatasource _remote;
  final SyncService _sync;

  // ── Read (always from Drift) ──────────────────────────────────────────────

  Stream<List<Category>> watchAll() => _dao.watchAll();
  Stream<Category?> watchById(String id) => _dao.watchById(id);

  // ── Write (Drift first, then Firestore if online) ─────────────────────────

  Future<void> save(Category category) async {
    await _dao.upsert(category);
    if (_sync.isOnline) {
      await _remote.save(category);
      await _dao.markSynced(category.id);
    }
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    if (_sync.isOnline) {
      await _remote.delete(id);
    }
  }

  Future<void> reorder(List<Category> ordered) async {
    for (var i = 0; i < ordered.length; i++) {
      await _dao.upsert(ordered[i].copyWith(sortOrder: i));
    }
    if (_sync.isOnline) {
      await _remote.reorder(ordered);
      for (final c in ordered) {
        await _dao.markSynced(c.id);
      }
    }
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db   = ref.watch(appDatabaseProvider);
  final uid  = ref.watch(_uidProvider);
  final sync = ref.watch(syncServiceProvider);
  return CategoryRepository(
    dao:    db.categoriesDao,
    remote: FirestoreCategoriesDatasource(uid),
    sync:   sync,
  );
});

final _uidProvider = Provider<String>(
  (ref) => ref.watch(currentUserIdProvider) ?? '',
);
