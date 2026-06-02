import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums.dart';
import '../../models/task.dart';
import '../local/app_database.dart';
import '../local/tasks_dao.dart';
import '../remote/firestore_tasks_datasource.dart';
import 'sync_service.dart';

class TaskRepository {
  TaskRepository({
    required TasksDao dao,
    required FirestoreTasksDatasource remote,
    required SyncService sync,
  })  : _dao = dao,
        _remote = remote,
        _sync = sync {
    // Mirror Firestore → Drift in background
    _remote.watchAll().listen(
      (tasks) async {
        for (final t in tasks) {
          await _dao.upsert(t);
          await _dao.markSynced(t.id);
        }
      },
      onError: (_) {},
    );
  }

  final TasksDao _dao;
  final FirestoreTasksDatasource _remote;
  final SyncService _sync;

  // ── Read ──────────────────────────────────────────────────────────────────

  Stream<List<Task>> watchAll()                 => _dao.watchAll();
  Stream<Task?> watchById(String id)            => _dao.watchById(id);
  Stream<List<Task>> watchForDate(DateTime d)   => _dao.watchForDate(d);
  Stream<List<Task>> watchOverdue()             => _dao.watchOverdue();

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> save(Task task) async {
    await _dao.upsert(task);
    if (_sync.isOnline) {
      await _remote.save(task);
      await _dao.markSynced(task.id);
    }
  }

  Future<void> delete(String id) async {
    await _dao.deleteById(id);
    if (_sync.isOnline) {
      await _remote.delete(id);
    }
  }

  Future<void> updateStatus(String id, TaskStatus status) async {
    await _dao.updateStatus(id, status);
    if (_sync.isOnline) {
      await _remote.updateStatus(id, status);
      await _dao.markSynced(id);
    }
  }

  Future<void> reschedule(String id, DateTime? dueDate) async {
    final task = await _dao.watchById(id).first;
    if (task == null) return;
    await save(task.copyWith(dueDate: dueDate));
    if (_sync.isOnline) {
      await _remote.updateDueDate(id, dueDate);
    }
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db   = ref.watch(appDatabaseProvider);
  final uid  = ref.watch(_uidProvider);
  final sync = ref.watch(syncServiceProvider);
  return TaskRepository(
    dao:    db.tasksDao,
    remote: FirestoreTasksDatasource(uid),
    sync:   sync,
  );
});

final _uidProvider = Provider<String>((_) => 'preview-user');
