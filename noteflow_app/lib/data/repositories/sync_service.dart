import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../remote/firestore_categories_datasource.dart';
import '../remote/firestore_notes_datasource.dart';
import '../remote/firestore_tasks_datasource.dart';

class SyncService {
  SyncService({
    required AppDatabase db,
    required String uid,
  })  : _db = db,
        _uid = uid {
    _init();
  }

  final AppDatabase _db;
  final String _uid;

  bool _online = true;
  bool get isOnline => _online;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  void _init() {
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);

    // Check initial state
    Connectivity().checkConnectivity().then((results) {
      _online = _hasConnection(results);
    });
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final wasOffline = !_online;
    _online = _hasConnection(results);
    if (wasOffline && _online) {
      flushPending();
    }
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }

  /// Pushes all locally-pending records to Firestore.
  Future<void> flushPending() async {
    await Future.wait([
      _flushCategories(),
      _flushNotes(),
      _flushTasks(),
    ]);
  }

  Future<void> _flushCategories() async {
    final remote  = FirestoreCategoriesDatasource(_uid);
    final pending = await _db.categoriesDao.getPending();
    for (final category in pending) {
      try {
        await remote.save(category);
        await _db.categoriesDao.markSynced(category.id);
      } catch (_) {}
    }
  }

  Future<void> _flushNotes() async {
    final remote  = FirestoreNotesDatasource(_uid);
    final pending = await _db.notesDao.getPending();
    for (final note in pending) {
      try {
        await remote.save(note);
        await _db.notesDao.markSynced(note.id);
      } catch (_) {}
    }
  }

  Future<void> _flushTasks() async {
    final remote  = FirestoreTasksDatasource(_uid);
    final pending = await _db.tasksDao.getPending();
    for (final task in pending) {
      try {
        await remote.save(task);
        await _db.tasksDao.markSynced(task.id);
      } catch (_) {}
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final syncServiceProvider = Provider<SyncService>((ref) {
  final db  = ref.watch(appDatabaseProvider);
  // uid stub — replaced in Phase 5 with real auth
  const uid = 'preview-user';
  final service = SyncService(db: db, uid: uid);
  ref.onDispose(service.dispose);
  return service;
});
